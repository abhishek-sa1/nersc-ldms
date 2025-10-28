#!/bin/bash

NS="telemetry"
TOPIC="nersc-ldms"
echo "[--] Test for k8s auth file"
if [ ! -f "~/.kube/config" ]; then
  echo "[!! Setup your k8s authenticaiton and try again"
  exit 1
fi

echo "[--] Test if we can talk to k8s api server"
kubectl version 
if [ $? -ne 0 ]; then
  echo "[!!] Failed to talk to k8s api."
  exit 1
fi

echo "[--] Test if namespace exists in k8s: $NS"
kubectl get namespaces |grep telemetry 
if [ ! $? -ne 0 ]; then
  echo "[>>] Crate namespace $NS"
  kubectl create namespace $NS
else
  echo "[>>] Found namespace $NS"
fi

echo "[--] Test if strimzi kafka is already installed"
helm -n telemetry  list  |grep strimzi-cluster-operator
#NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION           
#strimzi-cluster-operator        telemetry           1               2025-05-19 23:53:45.156310167 +0000 UTC deployed        strimzi-kafka-operator-0.46.0   0.46.0      
if [ ! $? -ne 0 ]; then
  echo "[>>] Install strimz kafkai"
  helm -n telemetry  install strimzi-cluster-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --version 0.47.0
else
  echo "[>>] Found strimz kafkai"
fi

#  Starting template kafka: https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/kafka/kraft/kafka.yaml
echo "[--] Test for the tamplate"
kubectl  -n telemetry get Kafka  && kubectl  -n telemetry get KafkaNodePool
#NAME      READY   METADATA STATE   WARNINGS
#cluster   True    KRaft            
#
#NAME         DESIRED REPLICAS   ROLES            NODEIDS
#broker       3                  ["broker"]       [3,4,5]
#controller   3                  ["controller"]   [0,1,2]
if [ ! $? -ne 0 ]; then
  echo "[>>] Install kafka.yaml"
  kubectl -n $NS apply -f kafka.kafka.yaml
else
  echo "[>>] Found KafkaNodePools"
fi
echo "[--] Test for Topic $TOPIC"
kubectl -n telemetry get kafkatopics.kafka.strimzi.io nersc-ldms
if [ ! $? -ne 0 ]; then
  echo "[>>] Install kafka topic nersc-ldms"
  kubectl -n $NS apply -f  kafka.topic.nersc-ldms.yaml
else
  echo "[>>] Found KafkaNodePools"
fi
echo "[--] Open two terminals to test the topic

# Consume the message
kubectl -n telemetry exec -it cluster-controller-0 -- bin/kafka-console-consumer.sh --bootstrap-server cluster-kafka-bootstrap:9092 --topic metricreports

# Produce a message
echo "This is a test" |  kubectl -n telemetry exec -it cluster-controller-0 -- /bin/bash bin/kafka-console-producer.sh --bootstrap-server cluster-kafka-bootstrap:9092 --topic metricreports --
i
The Consume should see 'This is a test'
"

