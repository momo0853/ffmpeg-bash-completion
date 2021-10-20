# 确定终端环境
```shell
$ echo $SHELL
```

# 如果不是bash环境，并且想改为bash环境
```shell
$ chsh -s /bin/bash
```

# 使用
- 当次有效
```shell
$ git clone https://github.com/momo0853/ffmpeg-bash-completion.git
$ cd ffmpeg-bash-completion && source ffmpeg.sh
```

- 每次有效

在`~/.bash_profile`中执行`source ffmpeg.sh`，这样终端每次打开都会执行一次
