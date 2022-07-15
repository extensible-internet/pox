FROM python:3

WORKDIR /pox

COPY . .

CMD [ "python", "./pox.py" ]
