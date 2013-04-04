function [aver, medianValue, SD, N] = organize_calcRatioStats(numerator, denominator)

    N1 = length(numerator(~isnan(numerator)));
    N2 = length(denominator(~isnan(denominator)));    
        N = N1 + N2;
    
    SD1 = nanstd(numerator);
    SD2 = nanstd(denominator);
        SD = sqrt((SD1^2) + (SD2^2));
    
    aver1 = nanmean(numerator);
    aver2 = nanmean(denominator);
        aver = aver1 / aver2;
    
    median1 = nanmedian(numerator);
    median2 = nanmedian(denominator);
        medianValue = median1 / median2;