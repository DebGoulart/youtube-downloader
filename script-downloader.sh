#! /usr/bin/env bash

# Testes iniciais

[ "$UID" -ne "0" ] && { echo "/nNecessita de root para executar o programa..." ; exit; }

if ! command -v curl &> /deb/null; then
    echo "Instalando dependencias..."
    sleep 1s
    apt install -y curl
fi

if ! command -v ffmpeg &> /dev/null; then
    apt install -y ffmpeg
fi

if ! wget -q --spider www.google.com; then
    echo "Usuário sem internet. Conecte-se para utilizar o programa."
    sleep 1s
    echo "Saindo do programa..."
    sleep 1s
    exit 1
fi

if ! command -v yt-dlp &> /dev/null; then
    echo "Instalando o programa..."
    sleep 1s
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
fi

# Instruções ao usuário

clear
echo "

Bem vindo!

Este programa permite baixar vídeos, áudios e playlists do YouTube, além de converter arquivos de audio e video.

O yt-dlp suporta diferentes opções formatos de audio.

Para vídeos, ele automaticamente irá baixar com a melhor qualidade ['best']
      
Para áudios, você deverá especificar o formato de audio, como:
        - mp3
        - m4a

Para converter arquivos, o programa suporta as seguintes opções de conversão:

        - Conversão de vídeo: mp4, avi, mkv
        - Conversão de áudio: mp3, m4a, wav
"

sleep 1s
echo "Pressione ENTER para continuar..."
read

# Menu de opções

clear
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Escolha uma das seguintes opções:

1- Baixar vídeo completo
2- Baixar somente áudio
3- Baixar playlist
4- Conversor
5- Sair

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
"
read -p "Digite o número correspondente à opção desejada: " option

case $option in
    1)
        clear
        read -p "Por favor insira o link: " video_link

        yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "$video_link"

	    echo "Video baixado com sucesso!"
    ;;

    2)
        read -p "Por favor insira o link: " audio_link
        read -p "Por favor selecione o tipo do áudio: " audio_type

        yt-dlp -x --audio-format "$audio_type" "$audio_link" -o "%(title)s.%(ext)s"

	downloaded_file="$(yt-dl
    p --get-filename -o "%(title)s.%(ext)s" "$audio_link")"
	
	file_name="${downloaded_file%.*}"

	ffmpeg -i "$downloaded_file" "$file_name.mp3"

	echo "/nAudio baixado e convertido para MP3 com sucesso!"
	exit 0
    ;;

    3)
        read -p "Por favor insira o link: " playlist_link
        yt-dlp -i --yes-playlist "$playlist_link"
    ;;

    4)
        clear
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        Qual tipo de arquivo deseja converter?

        1- Vídeo
        2- Áudio
        3- Sair

        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        "
        read -p "Digite o número correspondente à opção desejada: " convert_option

        if [ "$convert_option" = "1" ]; then
            read -p "Por favor insira o caminho do vídeo: " video_path
            read -p "Por favor insira o nome para o arquivo de saída [COM EXTENSÃO ex: .mp4]: " output_name

            if [ -f "$video_path" ]; then
		    ffmpeg -i "$video_path" "$output_name"
		    echo "Conversão concluída com sucesso!"
	    else
		    echo "Arquivo de vídeo não encontrado."
	    fi


        elif [ "$convert_option" = "2" ]; then
            read -p "Por favor insira o caminho do áudio: " audio_path
            read -p "Por favor insira o nome para o arquivo de saída [COM EXTENSÃO ex: .mp3]: " output_name

            if [ -f "$audio_path" ]; then
		    ffmpeg -i "$audio_path" "$output_name"
		    echo "Conversão concluída com sucesso!"
	    else
		    echo "Arquivo de áudio não encontrado."
	    fi


        elif [ "$convert_option" = "3" ]; then
            echo "Saindo do programa..."
            sleep 1s
            exit 0
        else
            echo "Opção inválida. Por favor, selecione uma opção válida"
            sleep 1s
            echo "Saindo do programa..."
            sleep 1s
            exit 1
        fi
    ;;

    5)
        echo "Saindo do programa..."
        sleep 1s
        exit 0
    ;;

    *)
        echo "Opção inválida. Por favor, selecione uma opção válida."
        sleep 1s
        echo "Saindo do programa..."
        sleep 1s
        exit 1
    ;;
esac