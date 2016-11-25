function [net, info] = convnn_mnist(type, varargin)
root = fileparts(mfilename('fullpath')) ;
% ---------------------- construct the net -----------------------
first_run = 1;
if (first_run)
    vl_setupnn;
    first_run = 0;
end

opts.batchNormalization = false ;
opts.network = [] ;
opts.networkType = 'simplenn' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

sfx = opts.networkType ;
if opts.batchNormalization
    sfx = [sfx '-bnorm'] ; 
end
opts.expDir = fullfile(root, 'data', ['mnist-baseline-' sfx]) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = fullfile(root, 'MNIST') ;
opts.imdbPath = fullfile(opts.dataDir, 'imdb.mat');
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;

% ---------------------- prepare the data -----------------------

if isempty(opts.network)
  net = convnn_init_mnist(type, 'batchNormalization', opts.batchNormalization, ...
    'networkType', opts.networkType) ;
else
  net = opts.network ;
  opts.network = [] ;
end

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = convnn_getMNISTimdb(opts) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

net.meta.classes.name = arrayfun(@(x)sprintf('%d',x),1:10,'UniformOutput',false) ;

% ---------------------- train the net -----------------------
[net, info] = cnn_train(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 3)) ;

% --------------------------------------------------------------------
function fn = getBatch(opts)
    fn = @(x,y) getSimpleNNBatch(x,y) ;
end

% --------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
end
end

