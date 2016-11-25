function imdb = convnn_getMNISTimdb(opts)

if ~exist(opts.dataDir, 'dir')
  mkdir(opts.dataDir) ;
end

path1 = fullfile(opts.dataDir, strcat('train-images','-','idx3-ubyte'));
path2 = fullfile(opts.dataDir, strcat('t10k-images','-','idx3-ubyte'));
path3 = fullfile(opts.dataDir, strcat('train-labels','-','idx1-ubyte'));
path4 = fullfile(opts.dataDir, strcat('t10k-labels','-','idx1-ubyte'));

gunzip(strcat(path1,'.gz'), opts.dataDir);
gunzip(strcat(path2,'.gz'), opts.dataDir);
gunzip(strcat(path3,'.gz'), opts.dataDir);
gunzip(strcat(path4,'.gz'), opts.dataDir);

f=fopen(path1,'r') ;
x1=fread(f,inf,'uint8');
fclose(f) ;
x1=permute(reshape(x1(17:end),28,28,60e3),[2 1 3]) ;

f=fopen(path2,'r') ;
x2=fread(f,inf,'uint8');
fclose(f) ;
x2=permute(reshape(x2(17:end),28,28,10e3),[2 1 3]) ;

f=fopen(path3,'r') ;
y1=fread(f,inf,'uint8');
fclose(f) ;
y1=double(y1(9:end)')+1;

f=fopen(path4,'r') ;
y2=fread(f,inf,'uint8');
fclose(f) ;
y2=double(y2(9:end)')+1 ;

set = [ones(1,numel(y1)) 3*ones(1,numel(y2))];
data = single(reshape(cat(3, x1, x2),28,28,1,[]));
dataMean = mean(data(:,:,:,set == 1), 4);
data = bsxfun(@minus, data, dataMean) ;

imdb.images.data = data ;
imdb.images.data_mean = dataMean;
imdb.images.labels = cat(2, y1, y2) ;
imdb.images.set = set ;
imdb.meta.sets = {'train', 'val', 'test'} ;
imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),0:9,'uniformoutput',false) ;