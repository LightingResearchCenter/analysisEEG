function init_parallelComputing(noOfCores)

    % from
    % http://www.mathworks.com/products/parallel-computing/examples.html?file=/products/demos/shipping/distcomp/paralleldemo_parfor_bobsled.html

    poolSize = matlabpool('size');
    
    if poolSize == 0
        warning('parallel:demo:poolClosed', ...
                'Initializing the matlabpool as it was not running');
        
        matlabpool(noOfCores)
        
    elseif poolSize ~= noOfCores
        
        warning('Changing the number of cores used')
        matlabpool close % stop
        matlabpool(noOfCores) % restart
        
    end
    
    % fprintf('This demo is running on %d MATLABPOOL workers.\n', matlabpool('size'));