{% set output_dir = pillar.get('output_dir','/tmp/outputdata') %}
{% set zipname = grains.get('id', 'no_id_set') %}
{% set bucketname = pillar.get('bucketname','com.bigbitbus.data.ingest') %}
create_tar_archive:
  module.run:
    - name: archive.tar
    - arg:
      - czf
      - /tmp/{{ zipname }}.tar.gz
      - {{ output_dir }}/*
    - kwarg:
      - cwd: /tmp


push_copy_to_master:
  module.run:
    - name: cp.push_dir
    - arg:
      - {{ output_dir }}
    - require:
      - create_tar_archive


put_copy_in_s3:
  modile.run:
    - name: s3.put
    - tgt: '[gc,aw,az,do]*'
    - arg:
      - {{ bucketname }}
      - {{ testbranch }}/{{ provider_id }}/{{ zipname }}.tar.gz
      - local_file=/tmp/{{ zipname }}.tar.gz
    - require:
      - create_tar_archive
