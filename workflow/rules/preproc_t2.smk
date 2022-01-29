
rule n4biasfield_t2w:
    input: 
        img = config['in_raw_T2w']
    output:
        img = bids(root='results/preproc',suffix='T2w.nii.gz',desc='n4',subject='{subject}'),
    threads: 2
    container: config['singularity']['prepdwi']
    group: 'preproc'
    shell:
        'ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS={threads} '
        'N4BiasFieldCorrection -d 3 -i {input.img} -o {output}'




rule resample:
    input: 
        img = bids(root='results/preproc',suffix='T2w.nii.gz',desc='n4',subject='{subject}'),
    params:
        resample = config['resample_init']
    output:
        img = bids(root='results/preproc',suffix='T2w.nii.gz',desc='resample',subject='{subject}'),
    threads: 2
    container: config['singularity']['prepdwi']
    group: 'preproc'
    shell:
        'c3d {input} -resample {params.resample} {output}'



rule pad:
    input: 
        img = bids(root='results/preproc',suffix='T2w.nii.gz',desc='resample',subject='{subject}'),
    params:
        pad = config['pad_init']
    output:
        img = bids(root='results/preproc',suffix='T2w.nii.gz',desc='pad',subject='{subject}'),
    threads: 2
    container: config['singularity']['prepdwi']
    group: 'preproc'

    shell:
        'c3d {input} -pad-to {params.pad} 0 {output}'


