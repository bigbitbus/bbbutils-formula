include:
  - .uploadresults

shutdown_vm:
  module.run:
    - name: system.shutdown
    - require:
      - sls: .uploadresults
