FROM frolvlad/alpine-glibc

RUN apk --no-cache add \
        binutils \
        curl \
        groff \
        less \
        bash \
        openssl \
        git \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples

# Install kubectl
ARG KUBECTL_VERSION=v1.18.0
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    mkdir -p ~/completions && \
    kubectl completion bash > ~/completions/kubectl.bash && \
    echo "source ~/completions/kubectl.bash" >> /etc/profile

# Install kpt
RUN curl -LO https://storage.googleapis.com/kpt-dev/latest/linux_amd64/kpt && \
    chmod +x ./kpt && \
    mv ./kpt /usr/local/bin/kpt

# Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
RUN mv ./kustomize /usr/local/bin/kustomize

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

ENTRYPOINT ["aws"]
