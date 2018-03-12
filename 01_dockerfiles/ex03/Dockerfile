FROM debian

RUN apt-get update && \
	apt-get install -y curl openssh-server ca-certificates && \
	curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash && \
	EXTERNAL_URL="http://localhost" apt-get install gitlab-ce

EXPOSE 443
EXPOSE 80
EXPOSE 22