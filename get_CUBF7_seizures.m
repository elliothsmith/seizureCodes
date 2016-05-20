%% [20150930] starting to look at CUBF7's seizures.

patient = 'CUBF7';
preictalMins = 2;
postictalMins = 5;

for sz = 7:15
    % looping over seizures.
    switch sz
        case 1
            seizureTime = '';
            file = '20160107-101047-002'
            % times in samples
            Fs = 3e4;
            onset = 3.15e6;   % in 2kHz 
            offset = 3.25e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';
            
            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 2
            seizureTime = '';
            file = '20160107-101047-002'
            % times in samples
            Fs = 3e4;
            onset = 3.45e6;
            offset = 3.6e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';
            
            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15

        case 3
            seizureTime = '';
            file = '20160107-101047-003'
            % times in samples
            Fs = 3e4;
            onset = 1.7e6;
            offset = 1.8e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 4
            seizureTime = '';
            file = '20160107-101047-003'
            % times in samples
            Fs = 3e4;
            onset = 2.6e6;
            offset = 2.65e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
	case 5
           seizureTime = '';
            file = '20160107-101047-003'
            % times in samples
            Fs = 3e4;
            onset = 3.5e6;
            offset = 3.6e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 6
           seizureTime = '';
            file = '20160107-101047-004'
            % times in samples
            Fs = 3e4;
            onset = 0.25e6;
            offset = 0.5e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 7
           seizureTime = '';
            file = '20160107-101047-004'
            % times in samples
            Fs = 3e4;
            onset = 1.75e6;
            offset = 2.1e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';
        
            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 8
           seizureTime = '';
            file = '20160107-101047-005'
            % times in samples
            Fs = 3e4;
            onset = 0.4e6;
            offset = 0.45e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';
        
            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 9
           seizureTime = '';
            file = '20160107-101047-005'
            % times in samples
            Fs = 3e4;
            onset = 1.5e6;
            offset = 1.65e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 10
           seizureTime = '';
            file = '20160107-101047-005'
            % times in samples
            Fs = 3e4;
            onset = 1.5e6;
            offset = 1.65e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';
        
            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15

        case 11
           seizureTime = '';
            file = '20160107-101047-005'
            % times in samples
            Fs = 3e4;
            onset = 2.25e6;
            offset = 2.35e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 12
           seizureTime = '';
            file = '20160107-101047-005'
            % times in samples
            Fs = 3e4;
            onset = 2.6e6;
            offset = 2.65e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 13
           seizureTime = '';
            file = '20160107-101047-006'
            % times in samples
            Fs = 3e4;
            onset = 2.4e6;
            offset = 2.5e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 14
           seizureTime = '';
            file = '20160107-101047-006'
            % times in samples
            Fs = 3e4;
            onset = 2.8e6;
            offset = 2.9e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';

            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15
        case 15
           seizureTime = '';
            file = '20160107-101047-006'
            % times in samples
            Fs = 3e4;
            onset = 3.1e6;
            offset = 3.2e6;
            path = '/mnt/mfs/patients/BF/CUBF7/20160107-101047/';
        
            onsetSecs = onset./Fs*15
            offsetSecs = offset./Fs*15


end
    
    % display(['for seizure ' num2str(sz)])
    preprocessSeizure(patient, sz, file, path, onset, offset, preictalMins, postictalMins,0)
    
	%% visualize seizures and save figures
	saveFlag = 1;
	visualizeSeizure(patient,sz,'all',saveFlag)
	
end
