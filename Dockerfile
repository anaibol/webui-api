FROM runpod/stable-diffusion:web-automatic-base-6.0.1

SHELL ["/bin/bash", "-c"]

ENV PATH="${PATH}:/workspace/stable-diffusion-webui/venv/bin"

WORKDIR /

# ADD  model.safetensors /
RUN wget -O model.safetensors https://civitai.com/api/download/models/51913 --content-disposition
RUN pip install runpod

WORKDIR /workspace/stable-diffusion-webui/

ADD test_input.json /src/

ADD cache.py .
RUN python cache.py --use-cpu=all --ckpt /model.safetensors

ADD api.py .

WORKDIR /

ADD handler.py .
ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "/start.sh" ]