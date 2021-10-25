#!/bin/bash

_ffmpeg()
{
    local cur=${COMP_WORDS[$COMP_CWORD]}
    local prev=${COMP_WORDS[$COMP_CWORD-1]}

    if [ -n "$prev" ] && [ "${prev:0:1}" = "-" ]; then # 针对特定'-'打头的命令再做进一步的补全
        case "$prev" in
        -ac|-a:c)
            COMPREPLY=( $(compgen -W "1 2 3 4 5 6 7 22" -- "$cur") ) ;;
        -af)
            COMPREPLY=( $(compgen -W "$(ffmpeg -filters 2>/dev/null | sed -n '/-/,$p' | grep -E A\+- -w | awk '{print $2}')" -- "$cur") ) ;;
        -vf)
            COMPREPLY=( $(compgen -W "$(ffmpeg -filters 2>/dev/null | sed -n '/-/,$p' | grep -E V\+- -w | awk '{print $2}')" -- "$cur") ) ;;
        -acodec|-c:a)
            COMPREPLY=( $(compgen -W "$(ffmpeg -encoders 2>/dev/null | sed -n '/--/,$p' | tail -n +2 | grep "^ A" | awk '{print $2}')" -- "$cur") ) ;;
        -cpuflags)
            COMPREPLY=( $(compgen -W "3dnow 3dnowext altivec armv5te armv6 armv6t2 armv8 athlon athlonxp atom avx avx2 bmi1 bmi2 cmov fma3 fma4 k6 k62 k8 mmx mmxext neon pentium2 pentium3 pentium4 setend sse sse2 sse2slow sse3 sse3slow sse4.1 sse4.2 ssse3 vfp vfpv3 xop") ) ;;
        -f)
            COMPREPLY=( $(compgen -W "$(ffmpeg -formats 2>/dev/null | sed -n '/--/,$p' | tail -n +2 | awk '{print $2}')" -- "$cur") ) ;;
        -c|-codec)
            COMPREPLY=( $(compgen -W "$(ffmpeg -codecs 2>/dev/null | sed -n '/--/,$p' | tail -n +2 | awk '{print $2}')" -- "$cur") ) ;;
        -discard)
            COMPREPLY=( $(compgen -W "none default noref bidir nokey all" -- "$cur") ) ;;
        -disposition)
            COMPREPLY=( $(compgen -W "default dub original comment lyrics karaoke forced hearing_impaired visual_impaired clean_effects attached_pic captions descriptions dependent metadata" -- "$cur") ) ;;
        -h|-\?|-help|--help)
            COMPREPLY=( $(compgen -W "long full decoder= encoder= demuxer= muxer= filter=" -- "$cur") ) ;;
        -hwaccel)
            COMPREPLY=( $(compgen -W "none auto $(ffmpeg -hwaccels 2>/dev/null | tail -n +2)" -- "$cur") ) ;;
        -init_hw_device)
            COMPREPLY=( $(compgen -W "cuda dxva2 vaapi vdpau qsv" -- "$cur") ) ;;
        -loglevel)
            COMPREPLY=( $(compgen -W "quiet panic fatal error warning info verbose debug trace" -- "$cur") ) ;;
        -movflags)
            COMPREPLY=( $(compgen -W "default_base_moof disable_chpl empty_moov faststart frag_custom frag_keyframe omit_tfhd_offset rtphint separate_moof" -- "$cur") ) ;;
        -preset)
            COMPREPLY=( $(compgen -W "ultrafast superfast veryfast faster fast medium slow slower veryslow placebo" -- "$cur") ) ;;
        -pix_fmt)
            COMPREPLY=( $(compgen -W "$(ffmpeg -pix_fmts 2>/dev/null | sed -n '/--/,$p' | tail -n +2 | awk '{print $2}')" -- "$cur") ) ;;
        -s)
            COMPREPLY=( $(compgen -W "ntsc pal qntsc qpal sntsc spal film ntsc-film sqcif qcif cif 4cif 16cif qqvga qvga vga svga xga uxga qxga sxga qsxga hsxga wvga wxga wsxga wuxga woxga wqsxga wquxga whsxga whuxga cga ega hd480 hd720 hd1080 2k 2kflat 2kscope 4k 4kflat 4kscope nhd hqvga wqvga fwqvga hvga qhd 2kdci 4kdci uhd2160 uhd4320" -- "$cur") ) ;;
        -v|-loglevel)
            COMPREPLY=( $(compgen -W "quiet panic fatal error warning info verbose debug trace" -- "$cur") ) ;;
        -vcodec|-c:v)
            COMPREPLY=( $(compgen -W "$(ffmpeg -encoders 2>/dev/null | sed -n '/--/,$p' | tail -n +2 | grep "^ V" | awk '{print $2}')" -- "$cur") ) ;;
        -vprofile|-profile:v)
            COMPREPLY=( $(compgen -W "baseline main high high10 high422 high444" -- "$cur") ) ;;
        -r)
            COMPREPLY=( $(compgen -W "ntsc pal qntsc qpal sntsc spal film ntsc-film" -- "$cur") ) ;;
        esac
    elif [ -n "$prev" ] && [ "${prev}" = "help" ]; then # 当第二个参数是help的时候自动补全的内容
        COMPREPLY=( $(compgen -W "-buildconf -formats -muxers -demuxers -devices -codecs -decoders -encoders -bsfs -protocols -filters -pix_fmts -layouts -sample_fmts -colors -sources -sinks -hwaccels" -- "$cur") )
    elif [ -n "$cur" ] && [ "${cur:0:1}" = "-" ]; then # 当第二个参数以'-'开通时，找到所有的-大头的命令作为自动补全内容
        COMPREPLY=( $(compgen -W "$(ffmpeg -h full 2>/dev/null | grep -e "^-" -e "^  -" | awk '{print $1}')" -- "$cur") )
    else [ -n "$cur" ]; ## 当只输入了ffmpeg时按table键自动补全的内容
        COMPREPLY=( $(compgen -W "\- help" -- "$cur") )
    fi
}

complete -o default -F _ffmpeg ffmpeg # 如果没有匹配的自动补全内容使用'readline'方式补全(当前文件名)
