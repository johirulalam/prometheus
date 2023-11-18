#!/bin/bash

# Define versions
PROMETHEUS_VERSION="2.30.3"
GRAFANA_VERSION="8.3.0"
NODE_EXPORTER_VERSION="1.2.2"
MYSQL_EXPORTER_VERSION="0.15.0"
ALERTMANAGER_VERSION="0.23.0"
PUSHGATEWAY_VERSION="1.4.0"

# Define ports
PROMETHEUS_PORT=9080
GRAFANA_PORT=3030
NODE_EXPORTER_PORT=9110
MYSQL_EXPORTER_PORT=9114
ALERTMANAGER_PORT=9393
PUSHGATEWAY_PORT=9491

# Function to install Prometheus
install_prometheus() {
  wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
  tar -xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
  mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 prometheus
  cd prometheus
  nohup ./prometheus --web.listen-address=":${PROMETHEUS_PORT}" > prometheus.log 2>&1 &
  cd -
}

# Function to install Grafana
install_grafana() {
  wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}-1.x86_64.rpm
  sudo yum install grafana-${GRAFANA_VERSION}-1.x86_64.rpm
  sudo systemctl start grafana-server
}

# Function to install Node Exporter
install_node_exporter() {
  wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
  tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
  mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 node_exporter
  cd node_exporter
  nohup ./node_exporter --web.listen-address=":${NODE_EXPORTER_PORT}" > node_exporter.log 2>&1 &
  cd -
}

# Function to install MySQL Exporter
install_mysql_exporter() {
  wget https://github.com/prometheus/mysqld_exporter/releases/download/v${MYSQL_EXPORTER_VERSION}/mysqld_exporter-${MYSQL_EXPORTER_VERSION}.linux-amd64.tar.gz
  tar -xvf mysqld_exporter-${MYSQL_EXPORTER_VERSION}.linux-amd64.tar.gz
  mv mysqld_exporter-${MYSQL_EXPORTER_VERSION}.linux-amd64 mysqld_exporter
  cd mysqld_exporter
  nohup ./mysqld_exporter --web.listen-address=":${MYSQL_EXPORTER_PORT}" > mysqld_exporter.log 2>&1 &
  cd -
}

# Function to install Alertmanager
install_alertmanager() {
  wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
  tar -xvf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
  mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64 alertmanager
  cd alertmanager
  nohup ./alertmanager --web.listen-address=":${ALERTMANAGER_PORT}" > alertmanager.log 2>&1 &
  cd -
}

# Function to install Pushgateway
install_pushgateway() {
  wget https://github.com/prometheus/pushgateway/releases/download/v${PUSHGATEWAY_VERSION}/pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64.tar.gz
  tar -xvf pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64.tar.gz
  mv pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64 pushgateway
  cd pushgateway
  nohup ./pushgateway --web.listen-address=":${PUSHGATEWAY_PORT}" > pushgateway.log 2>&1 &
  cd -
}

# Execute installation functions
install_prometheus
install_grafana
install_node_exporter
install_mysql_exporter
install_alertmanager
install_pushgateway
