#!/bin/sh
# License: GNU General Public License v3.0
# Author: https://github.com/thimc
# Reference: https://github.com/thimc/lfimg

# Modified by: Me
if [ -f "$1" ]; then
  FILENAME="$1"
elif [ "$lf_trash_restore" ]; then
  if [ -f "$HOME/.local/share/Trash/files/$(basename "$(printf "%s" "${1}" | awk '{print $4}')")" ]; then
    FILENAME="$HOME/.local/share/Trash/files/$(basename "$(printf "%s" "${1}" | awk '{print $4}')")"
  fi
elif [ -n "$f" ] && [ -f "$(dirname "$f")/$(printf "%s" "$1" | awk -F ":" '{print $1}')" ]; then
  FILENAME="$(dirname "$f")/$(printf "%s" "$1" | awk -F ":" '{print $1}')"
fi

if [ -z "$FILENAME" ]; then
  echo "NO PREVIEW FILE AVAILABLE!"
  exit 0
fi

PREVIEW_COLUMNS=${2:-${FZF_PREVIEW_COLUMNS}}
PREVIEW_LINES=${3:-${FZF_PREVIEW_LINES}}

if [ ! -d "$HOME/.cache/preview" ]; then
  mkdir -p "$HOME/.cache/preview"
fi
CACHE="$HOME/.cache/preview/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' \
  -- "$(readlink -f "${FILENAME}")" | sha256sum | awk '{print $1}')"

BAT_OPTIONS="--color=always --pager=never"

image() {
  # Limit max size of file to 80x50
  # This prevents CPU exhausting
  if [ "${2}" -gt 80 ]; then
    PREVIEW_COLUMNS=80
  else
    PREVIEW_COLUMNS=${2}
  fi
  if [ "${3}" -gt 50 ]; then
    PREVIEW_LINES=50
  else
    PREVIEW_LINES=${3}
  fi
	chafa -f sixel -s "${PREVIEW_COLUMNS}x${PREVIEW_LINES}" --animate off --polite on "${1}"
}


case "$(printf "%s\n" "$(readlink -f "${FILENAME}")" | awk '{print tolower($0)}')" in
  *.tgz|*.tar.gz) tar tzf "${FILENAME}" ;;
  *.tar.bz2|*.tbz2) tar tjf "${FILENAME}" ;;
  *.tar.txz|*.txz) xz --list "${FILENAME}" ;;
  *.tar) tar tf "${FILENAME}" ;;
  *.zip|*.jar|*.war|*.ear|*.oxt) unzip -l "${FILENAME}" ;;
  *.gz) gzip -l "${FILENAME}" ;;
  *.rar) unrar l "${FILENAME}" ;;
  *.md) glow "${FILENAME}";;
  *.7z) 7z l "${FILENAME}" ;;
  *.[1-8]) man "${FILENAME}" | col -b ;;
  *.o) nm "${FILENAME}";;
  *.torrent) transmission-show "${FILENAME}" ;;
  *.iso) iso-info --no-header -l "${FILENAME}" ;;
  *.odt|*.ods|*.odp|*.sxw) odt2txt "${FILENAME}" ;;
  *.doc) if [ "$(uname)" = "darwin" ]; then textutil -stdout -cat txt "${FILENAME}" | bat $BAT_OPTIONS; else catdoc "${FILENAME}"; fi;;
  *.docx) docx2txt "${FILENAME}" ;;
  *.xml|*.html) w3m -dump "${FILENAME}";;
  *.xls|*.xlsx)
    ssconvert --export-type=Gnumeric_stf:stf_csv "${FILENAME}" "fd://1" | bat $BAT_OPTIONS --language=csv
    ;;
  *.csv)
    bat $BAT_OPTIONS --language=csv "${FILENAME}" ;;
  *.wav|*.mp3|*.flac|*.m4a|*.wma|*.ape|*.ac3|*.og[agx]|*.spx|*.opus|*.as[fx]|*.mka)
    exiftool "${FILENAME}"
    ;;
  *.pdf)
    [ ! -f "${CACHE}.jpg" ] && pdftoppm -jpeg -f 1 -singlefile "${FILENAME}" "$CACHE"
    image "${CACHE}.jpg" "${PREVIEW_COLUMNS}" "${PREVIEW_LINES}" "$4" "$5"
    ;;
  *.epub)
    [ ! -f "$CACHE" ] && epub-thumbnailer "${FILENAME}" "$CACHE" 1024
    image "$CACHE" "${PREVIEW_COLUMNS}" "${PREVIEW_LINES}" "$4" "$5"
    ;;
  *.cbz|*.cbr|*.cbt)
    [ ! -f "$CACHE" ] && comicthumb "${FILENAME}" "$CACHE" 1024
    image "$CACHE" "${PREVIEW_COLUMNS}" "${PREVIEW_LINES}" "$4" "$5"
    ;;
  *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
    [ ! -f "${CACHE}.jpg" ] && \
      ffmpegthumbnailer -i "${FILENAME}" -o "${CACHE}.jpg" -s 0 -q 5
    image "${CACHE}.jpg" "${PREVIEW_COLUMNS}" "${PREVIEW_LINES}" "$4" "$5"
    ;;
  *.bmp|*.jpg|*.jpeg|*.png|*.xpm|*.webp|*.tiff|*.gif|*.jfif|*.ico)
    image "${FILENAME}" "${PREVIEW_COLUMNS}" "${PREVIEW_LINES}" "$4" "$5"
    ;;
  *.svg)
    [ ! -f "${CACHE}.jpg" ] && convert "${FILENAME}" "${CACHE}.jpg"
    image "${CACHE}.jpg" "${PREVIEW_COLUMNS}" "${PREVIEW_LINES}" "$4" "$5"
    ;;
  *) bat $BAT_OPTIONS "${FILENAME}"
esac
exit 0
