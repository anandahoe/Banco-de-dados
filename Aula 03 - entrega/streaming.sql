-- CREATE DATABASE streaming

CREATE TABLE IF NOT EXISTS public.artistas(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(256) NOT NULL,
	biografia TEXT,
	pais_origem VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS public.usuarios(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(256) NOT NULL,
	login VARCHAR(256) NOT NULL UNIQUE,
	email VARCHAR(256) NOT NULL UNIQUE,
	data_nascimento DATE NOT NULL,
	pais VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS public.generos(
	id SERIAL PRIMARY KEY,
	genero VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.albuns(
	id SERIAL PRIMARY KEY,
	titulo VARCHAR(256) NOT NULL,
	data_lancamento DATE,
	artista_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.playlists(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(256) NOT NULL,
	descricao TEXT,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	usuario_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.seguidores(
	id SERIAL PRIMARY KEY,
	usuario_seguidor_id INT NOT NULL,
	usuario_seguido_id INT,
	artista_seguido_id INT
);

CREATE TABLE IF NOT EXISTS public.musicas(
	id SERIAL PRIMARY KEY,
	titulo VARCHAR(256) NOT NULL,
	duracao TIMESTAMP NOT NULL,
	data_lancamento DATE NOT NULL,
	artista_id INT NOT NULL,
	album_id INT
);

CREATE TABLE IF NOT EXISTS public.generos_musicas(
	genero_id INT,
	musica_id INT,
	PRIMARY KEY (genero_id, musica_id)
);

CREATE TABLE IF NOT EXISTS public.musicas_reproduzidas(
	id SERIAL PRIMARY KEY,
	ouvida_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	usuario_id INT NOT NULL,
	musica_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.musicas_playlists(
	musica_id INT,
	playlist_id INT,
	PRIMARY KEY (musica_id, playlist_id)
);

CREATE TABLE IF NOT EXISTS public.albuns_generos(
	album_id INT,
	genero_id INT,
	PRIMARY KEY (album_id, genero_id)
);

-- Adicionando as chaves-estrangeiras

ALTER TABLE IF EXISTS public.albuns
ADD FOREIGN KEY (artista_id)
REFERENCES public.artistas(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.playlists
ADD FOREIGN KEY (usuario_id)
REFERENCES public.usuarios(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.albuns_generos
ADD FOREIGN KEY (album_id)
REFERENCES public.albuns(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.albuns_generos
ADD FOREIGN KEY (genero_id)
REFERENCES public.generos(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.musicas_playlists
ADD FOREIGN KEY (musica_id)
REFERENCES public.musicas(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.musicas_playlists
ADD FOREIGN KEY (playlist_id)
REFERENCES public.playlists(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.seguidores
ADD FOREIGN KEY (usuario_seguidor_id)
REFERENCES public.usuarios(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.seguidores
ADD FOREIGN KEY (usuario_seguido_id)
REFERENCES public.usuarios(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.seguidores
ADD FOREIGN KEY (artista_seguido_id)
REFERENCES public.artistas(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.musicas
ADD FOREIGN KEY (artista_id)
REFERENCES public.artistas(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.musicas
ADD FOREIGN KEY (album_id)
REFERENCES public.albuns(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.musicas_reproduzidas
ADD FOREIGN KEY (usuario_id)
REFERENCES public.usuarios(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.musicas_reproduzidas
ADD FOREIGN KEY (musica_id)
REFERENCES public.musicas(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.generos_musicas
ADD FOREIGN KEY (musica_id)
REFERENCES public.musicas(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.generos_musicas
ADD FOREIGN KEY (genero_id)
REFERENCES public.generos(id)
ON UPDATE CASCADE
ON DELETE CASCADE;