function net = convnn_init_mnist(type, varargin)

opts.batchNormalization = true ;
opts.networkType = 'simplenn' ;
opts = vl_argparse(opts, varargin);

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;

switch(type)
    case 'sample'
        % ------------------------ Sample ----------------------------------
        % conv5 - pool - conv5 - pool - conv4 - relu - fc - softmaxloss
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(5,5,1,20, 'single'), zeros(1, 20, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(5,5,20,50, 'single'),zeros(1,50,'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(4,4,50,500, 'single'),  zeros(1,500,'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu') ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(1,1,500,10, 'single'), zeros(1,10,'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
        if opts.batchNormalization
          net = insertBnorm(net, 1) ;
          net = insertBnorm(net, 4) ;
          net = insertBnorm(net, 7) ;
        end
        
    case 'shallow'
        % --------------------- a shallow CNN ------------------
        % conv27 - pool - relu - fc - softmax
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(27,27,1,200, 'single'), zeros(1, 200, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu');
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(1,1,200,10, 'single'),zeros(1,10,'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
        if opts.batchNormalization
          net = insertBnorm(net, 1) ;
        end
    case 'deep'
        % ------------------ a deep CNN ------------------------
        % conv5 - pool - conv3(padding) - conv3 - conv3 - conv3 - pool
        %  - conv3(padding) - conv3 - fc - softmax
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(5,5,1,20, 'single'), zeros(1, 20, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(3,3,20,50, 'single'), zeros(1, 50, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 1) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(3,3,50,100, 'single'), zeros(1, 100, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu');
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(3,3,100,200, 'single'), zeros(1, 200, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(3,3,200,200, 'single'), zeros(1, 200, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu');
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(3,3,200,200, 'single'), zeros(1, 200, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 1) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(3,3,200,1000, 'single'), zeros(1, 1000, 'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu');
        net.layers{end+1} = struct('type', 'conv', ...
                                   'weights', {{f*randn(1,1,1000,10, 'single'),zeros(1,10,'single')}}, ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
        if opts.batchNormalization
            net = insertBnorm(net, 1) ;
            net = insertBnorm(net, 8) ;
            net = insertBnorm(net, 13) ;
        end
end

% some meta parameters
net.meta.inputSize = [28 28 1] ;
net.meta.trainOpts.learningRate = 0.001 ;
net.meta.trainOpts.numEpochs = 20 ;
net.meta.trainOpts.batchSize = 100 ;

% Fill in defaul values
net = vl_simplenn_tidy(net) ;

% --------------------------------------------------------------------
function net = insertBnorm(net, l)
assert(isfield(net.layers{l}, 'weights'));
ndim = size(net.layers{l}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
               'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
               'learningRate', [1 1 0.05], ...
               'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;