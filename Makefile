APP = bootstrap

ARCH = x86_64-unknown-linux-musl
FUNCTION = rustTest
ZIP = lambda.zip
JSON_OUTPUT = $(FUNCTION).json

AWS_ROLE_ARN = arn:aws:iam::XXXX:role/lambda_test_full

AWS_PROFILE = --profile pawel.przeniczny@airhelp.com
AWS_REGION = --region eu-west-1

build:
	cargo build --release --target $(ARCH)

zip:
	zip -j $(ZIP) target/$(ARCH)/release/$(APP)

deploy: build zip
	aws $(AWS_PROFILE) $(AWS_REGION) lambda create-function \
		--function-name $(FUNCTION) \
		--role $(AWS_ROLE_ARN) \
		--zip-file fileb://./$(ZIP) \
		--environment Variables={RUST_BACKTRACE=1} \
		--handler doesnt.matter \
		--runtime provided \
		--tracing-config Mode=Active

update: build zip
	aws $(AWS_PROFILE) $(AWS_REGION) lambda update-function-code \
		--function-name $(FUNCTION) \
		--zip-file fileb://./$(ZIP) \

delete:
	aws $(AWS_PROFILE) $(AWS_REGION) lambda delete-function \
		--function-name $(FUNCTION)

invoke:
	aws $(AWS_PROFILE) $(AWS_REGION) lambda invoke \
		--function-name $(FUNCTION) \
    --payload '{ "greeting": "🤙", "name": "Rust + λ"}' \
		$(JSON_OUTPUT)

test: invoke
	jq . $(JSON_OUTPUT)
