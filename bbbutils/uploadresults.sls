{% set output_dir = pillar.get('output_dir','/tmp/outputdata') %}
{% set zipname = grains.get('id', 'no_id_set') %}
{% set bucketname = pillar.get('bucketname','com.bigbitbus.data.ingest') %}
{% set testbranch = grains.get('testgitref','not-defined') %}
{% set platformgrain = grains.get('platformgrain','not-defined') %}

create_tar_archive:
  module.run:
    - name: archive.tar
    - options: czf
    - dest: /tmp
    - tarfile: {{ zipname }}.tar.gz
    - sources:  {{ output_dir }}/*
    - cwd: /tmp

push_copy_to_master:
  module.run:
    - name: cp.push
    - path: /tmp/{{ zipname }}.tar.gz
    - require:
      - create_tar_archive


put_copy_in_s3:
  module.run:
    - name: s3.put
    - bucket: {{ bucketname }}
    - path: {{ testbranch }}/{{ platformgrain }}/{{ zipname }}.tar.gz
    - local_file: /tmp/{{ zipname }}.tar.gz
    - require:
      - create_tar_archive