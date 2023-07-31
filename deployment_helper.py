import os
import sys
from dotenv import load_dotenv


load_dotenv()
def ge(key):
    return os.getenv(key)
argument = sys.argv[1]
HELPER_SUBNET_FLAG = ge('HELPER_SUBNET_FLAG')

if argument == HELPER_SUBNET_FLAG:
    output = """apiVersion: rds.services.k8s.aws/v1alpha1
kind: DBInstance
metadata:
  name: "{RDS_SUBNET_GROUP_NAME}"
  namespace: {APP_NAMESPACE}
spec:
  name: {RDS_SUBNET_GROUP_NAME}
  description: "{RDS_SUBNET_GROUP_DESCRIPTION}"
  subnetIDs:
    {SUBNET_IDS}
  tags: []
""".format(RDS_SUBNET_GROUP_NAME = ge("RDS_SUBNET_GROUP_NAME"),
           APP_NAMESPACE = ge("APP_NAMESPACE"),
           RDS_SUBNET_GROUP_DESCRIPTION = ge("RDS_SUBNET_GROUP_DESCRIPTION"),
           SUBNET_IDS = '    '.join([""+ "-"+x + "\n" for x in ge("EKS_SUBNET_IDS").split("\t")]))

    text_file = open(ge("SUBNET_GROUP_FILE"), "wt")
    n = text_file.write(output)
    text_file.close()

