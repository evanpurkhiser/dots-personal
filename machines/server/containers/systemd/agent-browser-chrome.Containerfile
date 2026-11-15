FROM docker.io/library/debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install --yes --no-install-recommends \
		ca-certificates \
		curl \
		dbus-x11 \
		fonts-dejavu-core \
		fonts-liberation \
		fonts-noto-color-emoji \
		fonts-noto-core \
		libgl1-mesa-dri \
		locales \
		mesa-vulkan-drivers \
		procps \
		pulseaudio \
		pulseaudio-utils \
		python3-pyatspi \
		socat \
		sway \
		swaybg \
		tini \
		wayvnc \
		xwayland \
	&& curl --fail --silent --show-error --location \
		--output /tmp/google-chrome.deb \
		https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	&& apt-get install --yes --no-install-recommends /tmp/google-chrome.deb \
	&& sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
	&& locale-gen \
	&& rm /tmp/google-chrome.deb \
	&& rm -rf /var/lib/apt/lists/* \
	&& dbus-uuidgen --ensure=/etc/machine-id \
	&& useradd --create-home --uid 1000 --shell /bin/bash browser \
	&& install --directory --owner browser --group browser /home/browser/profile

COPY --chmod=0755 agent-browser-chrome-entrypoint /usr/local/bin/agent-browser-chrome-entrypoint
COPY agent-browser-chrome-sway-config /etc/sway/browser-config

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ=America/New_York

USER browser
WORKDIR /home/browser

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/agent-browser-chrome-entrypoint"]
