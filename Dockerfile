#only used in .github/workflows
#for manual builds use DockerfileAmd or DockerfileARM

ARG VERSION=prod
FROM ghcr.io/senergy-platform/process-engine:${TARGETARCH}-${VERSION}