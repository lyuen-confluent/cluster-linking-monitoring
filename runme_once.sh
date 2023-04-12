#!/bin/bash

echo ">>> Download jmx-monitoring-stacks.."
if [ ! -d "jmx-monitoring-stacks" ]
then
    git clone https://github.com/confluentinc/jmx-monitoring-stacks.git
else
    echo ">>> jmx-monitoring-stacks directory already exists"
fi

echo ">>> copying files to jmx-monitoring-stacks..."
cp monitoring/cluster-linking.json ./jmx-monitoring-stacks/jmxexporter-prometheus-grafana/assets/grafana/provisioning/dashboards/
cp monitoring/prometheus.yml ./jmx-monitoring-stacks/jmxexporter-prometheus-grafana/assets/prometheus/prometheus-config/
cp monitoring/kafka_broker.yml ./jmx-monitoring-stacks/shared-assets/jmx-exporter/
echo ">>> done"
