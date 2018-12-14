# Rust + λ 

Based on example from https://github.com/awslabs/aws-lambda-rust-runtime

### Prerequisites:
* Install: rust, aws cli, zip
* (on MacOS) install libc cross-compiler
```sh 
brew install filosottile/musl-cross/musl-cross && \
    ln -s /usr/local/bin/x86_64-linux-musl-gcc /usr/local/bin/musl-gcc
```

### 1. Build
```sh
cargo build --release --target x86_64-unknown-linux-musl 
```

### 2. Deploy
NOTE: create IAM role first (here _lambda_test_ role is used)

```sh
zip -j lambda.zip target/x86_64-unknown-linux-musl/release/bootstrap

aws lambda create-function --function-name rustTest \
    --handler doesnt.matter \
    --zip-file fileb://./lambda.zip \
    --runtime provided \
    --role arn:aws:iam::XXXXXXXXXX:role/lambda_test \
    --environment Variables={RUST_BACKTRACE=1} \
    --tracing-config Mode=Active
```

### 3. ???

### 4. Profit!
```sh 
aws lambda invoke \
    --function-name rustTest \
    --payload '{ "greeting": "howdy! 🤙", "name": "Rust + λ"}'
    output.json
    
jq . output.json
```

Or use Makefile FTW!:
```sh 
make deploy test
```

### Resources
Rust runtime for AWS Lambda: https://github.com/awslabs/aws-lambda-rust-runtime

Setting it up: https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/

