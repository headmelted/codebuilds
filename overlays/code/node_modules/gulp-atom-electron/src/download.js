'use strict';

var os = require('os');
var path = require('path');
var fs = require('fs');
var mkdirp = require('mkdirp');
var GitHub = require('github-releases-ms');
var ProgressBar = require('progress');
var semver = require('semver');
var rename = require('gulp-rename');
var es = require('event-stream');
var zfs = require('gulp-vinyl-zip');
var filter = require('gulp-filter');
var assign = require('object-assign');

var cachePath = path.join(os.tmpdir(), 'gulp-electron-cache');

function cache(assetName, repo, onMiss, cb) {
	var assetFolder = path.join(cachePath, repo);
	mkdirp(assetFolder, function (err) {
		if (err) { return cb(err); }

		var assetPath = path.join(assetFolder, assetName);

		fs.exists(assetPath, function (exists) {
			if (exists) { return cb(null, assetPath); }

			var tempAssetPath = assetPath + '.tmp';
			onMiss(tempAssetPath, function (err) {
				if (err) { return cb(err); }

				fs.rename(tempAssetPath, assetPath, function (err) {
					if (err) { return cb(err); }

					cb(null, assetPath);
				});
			});
		});
	});
}

function download(opts, cb) {
	var repo = opts.repo || 'atom/electron';
	var github = new GitHub({ repo: repo, token: opts.token });

	if (!opts.version) {
		return cb(new Error('Missing version'));
	}

	var platform = opts.platform;
	if (!platform) {
		return cb(new Error('Missing platform'));
	}

	var arch = opts.arch;

	if (!arch) {
		switch (platform) {
			case 'darwin': arch = 'x64'; break;
			case 'win32': arch = 'ia32'; break;
			case 'linux': arch = 'ia32'; break;
		}
	}

	var version = 'v' + opts.version;
	var assetName = [opts.assetName, version, platform, arch].join('-') + '.zip';

	function download(assetPath, cb) {
		github.getReleases({ tag_name: version }, function (err, releases) {
			if (err) { return cb(err); }

			var release = releases[0];

			if (!release) {
				return cb(new Error('No release ' + opts.version + ' found'));
			}

			var asset = release.assets.filter(function (asset) {
				return asset.name === assetName;
			})[0];

			if (!asset) {
				return cb(new Error('No asset for version ' + opts.version + ', platform ' + platform + ' and arch ' + arch + ' found'));
			}

			github.downloadAsset(asset, function (err, istream) {
				if (err) {
					console.error('Error creating download stream to download ' + asset.name);
					return cb(err);
				}

				if (process.stdout.isTTY && !opts.quiet) {
					var bar = new ProgressBar('↓ ' + asset.name + ' [:bar] :percent', {
						total: asset.size,
						width: 20
					});

					istream.on('data', function (chunk) { bar.tick(chunk.length); });
				} else {
					console.log('Downloading ' + asset.name + '...');
				}

				var ostream = fs.createWriteStream(assetPath);
				istream.pipe(ostream);
				istream.on('error', function (err) {
					console.error('Error in input stream while downloading ' + asset.name);
					cb(err);
				});
				ostream.on('error', function (err) {
					console.error('Error in output stream while downloading ' + asset.name);
					cb(err);
				});
				ostream.on('close', function () {
					console.log('Downloaded ' + asset.name);
					cb();
				});
			});
		});
	}

	cache(assetName, repo, download, cb);
}

function getDarwinLibFFMpegPath(opts) {
	return path.join('Electron.app', 'Contents', 'Frameworks', 'Electron Framework.framework', 'Versions', 'A', 'Libraries', 'libffmpeg.dylib');
}

module.exports = function (opts) {
	var electron = es.through();
	var ffmpeg = es.through();

	var downloadOpts = {
		version: opts.version,
		platform: opts.platform,
		arch: (opts.arch == 'arm' ? 'armv7l' : opts.arch),
		assetName: semver.gte(opts.version, '0.24.0') ? 'electron' : 'atom-shell',
		token: opts.token,
		quiet: opts.quiet,
		repo: opts.repo
	};

	download(downloadOpts, function (err, vanilla) {
		if (err) { return electron.emit('error', err); }
		zfs.src(vanilla)
			.pipe(opts.ffmpegChromium ? filter(['**', '!**/*ffmpeg.*']) : es.through())
			.pipe(electron);
	});

	if (opts.ffmpegChromium) {
		download(assign({}, downloadOpts, { assetName: 'ffmpeg' }), function (err, vanilla) {
			if (err) { return ffmpeg.emit('error', err); }

			zfs.src(vanilla)
				.pipe(filter('**/*ffmpeg.*'))
				.pipe(opts.platform === 'darwin' ? rename(getDarwinLibFFMpegPath(opts)) : es.through())
				.pipe(ffmpeg);
		});
	} else {
		ffmpeg = es.readArray([]);
	}

	return es.merge(electron, ffmpeg);
};
