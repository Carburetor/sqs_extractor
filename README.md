# Sqs Extractor
Helps extracting all messages from SQS queue, gets the ids into `reports.txt`
file

## Required environment variables

```bash
export AWS_ACCESS_KEY_ID='youridhere'
export AWS_SECRET_ACCESS_KEY='yourkeyhere'
export AWS_REGION='us-west-2'
```

## How to call
Call with queue name:

    bundle exec ruby start.rb '320-sqs-stage-delivery'
