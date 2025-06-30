function outPath = generate_spectrogram(filePath, outDir)
    [signal, fs] = audioread(filePath);
    if size(signal,2) > 1
        signal = mean(signal, 2);  % convert to mono
    end

    % Spectrogram settings
    window = hann(2048);
    noverlap = 1024;
    nfft = 2048;

    [s, f, t] = spectrogram(signal, window, noverlap, nfft, fs);
    spec_dB = 20 * log10(abs(s) + eps);    % Convert to dB
    spec_dB = max(spec_dB, -120);          % Clip to -120 dB floor

    % Create figure for image output
    fig = figure('Visible', 'off', 'Color', 'k');
    imagesc(t, f, spec_dB, [-120 0]);      %  dB scale range
    axis xy off;
    colormap(custom_spek_colormap());
    colorbar('Ticks', -120:20:0, 'Color', 'w');

    % Save image
    [~, name, ~] = fileparts(filePath);
    outPath = fullfile(outDir, [name, '_spectrogram.png']);
    set(fig, 'InvertHardcopy', 'off');     % Preserve black background
    print(fig, outPath, '-dpng', '-r150'); % Save with good resolution
    close(fig);
end

function cmap = custom_spek_colormap()
    %  black → blue → pink → red → orange → yellow → white
    n = 256;
    cmap = zeros(n, 3);
    for i = 1:n
        t = (i - 1) / (n - 1);
        if t < 0.2
            cmap(i,:) = [0, 0, 0.5 + 2.5*t];         % black → blue
        elseif t < 0.4
            cmap(i,:) = [5*(t - 0.2), 0, 1];         % blue → magenta
        elseif t < 0.6
            cmap(i,:) = [1, 0, 1 - 5*(t - 0.4)];     % pink → red
        elseif t < 0.8
            cmap(i,:) = [1, 5*(t - 0.6), 0];         % red → yellow
        else
            cmap(i,:) = [1, 1, 5*(t - 0.8)];         % yellow → white
        end
    end
    cmap = min(cmap, 1);
end
