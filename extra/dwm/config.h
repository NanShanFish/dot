#include <X11/XF86keysym.h>

static int showsystray                   = 1;         /* 是否显示托盘栏 */
static const int newclientathead         = 0;         /* 定义新窗口在栈顶还是栈底 */
static const int managetransientwin      = 1;         /* 是否管理临时窗口 */
static const unsigned int borderpx       = 2;         /* 窗口边框大小 */
static const unsigned int systraypinning = 1;         /* 托盘跟随的显示器 0代表不指定显示器 */
static const unsigned int systrayspacing = 0;         /* 托盘间距 */
static const unsigned int systrayspadding = 0;        /* 托盘和状态栏的间隙 */
static int gappi                          = 5;        /* 窗口与窗口 缝隙大小 */
static int gappo                          = 5;        /* 窗口与边缘 缝隙大小 */
static const int _gappo                  = 12;        /* 窗口与窗口 缝隙大小 不可变 用于恢复时的默认值 */
static const int _gappi                  = 12;        /* 窗口与边缘 缝隙大小 不可变 用于恢复时的默认值 */
static const int vertpad                 = 0;         /* vertical padding of bar */
static const int sidepad                 = 5;         /* horizontal padding of bar */
static const int overviewgappi           = 12;        /* overview时 窗口与边缘 缝隙大小 */
static const int overviewgappo           = 12;        /* overview时 窗口与窗口 缝隙大小 */
static const int showbar                 = 1;         /* 是否显示状态栏 */
static const int topbar                  = 1;         /* 指定状态栏位置 0底部 1顶部 */
static const float mfact                 = 0.65;      /* 主工作区 大小比例 */
static const int   nmaster               = 1;         /* 主工作区 窗口数量 */
static const unsigned int snap           = 5;         /* 边缘依附宽度 */
static const unsigned int baralpha       = 0xd0;      /* 状态栏透明度 */
static const unsigned int borderalpha    = 0xdd;      /* 边框透明度 */
static const char *fonts[]               = { "Maple Mono NF CN:style=medium:size=10"};

static const char *colors[][3] = {          /* 颜色设置 ColFg, ColBg, ColBorder */
    [SchemeNorm]      = { "#626880" , "#303446", "#626880" },
    [SchemeSel]       = { "#a6d189" , "#303446", "#a6d189" },
    [SchemeSelGlobal] = { "#e5c890", "#303446", "#e5c890" },
    [SchemeHid]       = { "#626880" , "#303446", NULL },
    [SchemeSystray]   = { NULL      , "#303446", NULL },
    [SchemeUnderline] = { "#303446"    , "#e78284",NULL },
    [SchemeNormTag]   = { "#b5bfe2" , "#303446", NULL },
    [SchemeSelTag]    = { "#e78284"   , "#303446", NULL },
    [SchemeBarEmpty]  = { NULL      , "#303446", NULL },
};
static const unsigned int alphas[][3]    = {          /* 透明度设置 ColFg, ColBg, ColBorder */
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel] = { OPAQUE, baralpha, borderalpha },
    [SchemeSelGlobal] = { OPAQUE, baralpha, borderalpha },
    [SchemeNormTag] = { OPAQUE, baralpha, borderalpha },
    [SchemeSelTag] = { OPAQUE, baralpha, borderalpha },
    [SchemeBarEmpty] = { 0, 0, 0 },
    [SchemeStatusText] = { OPAQUE, baralpha, borderalpha },
};

/* 自定义脚本位置 */
static const char *autostartscript = "$DWM/autostart.sh";
static const char *statusbarscript = "$DWM/statusbar/statusbar.sh";

/* 自定义 scratchpad instance */
static const char scratchpadname[] = "scratchpad";

/* 自定义tag名称 */
/* 自定义特定实例的显示状态 */
static const char *tags[] = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "", //tag 9: 放一些聊天的软件 super 0
};

/* 自定义窗口显示规则 */
/* class instance title 主要用于定位窗口适合哪个规则 */
/* tags mask 定义符合该规则的窗口的tag 0 表示当前tag */
/* isfloating 定义符合该规则的窗口是否浮动 */
/* isglobal 定义符合该规则的窗口是否全局浮动 */
/* isnoborder 定义符合该规则的窗口是否无边框 */
/* monitor 定义符合该规则的窗口显示在哪个显示器上 -1 为当前屏幕 */
/* floatposition 定义符合该规则的窗口显示的位置 0 中间，1到9分别为9宫格位置，例如1左上，9右下，3右上 */
static const Rule rules[] = {
    /* class                 instance              title             tags mask     isfloating  isglobal    isnoborder monitor floatposition */
    /** 优先级高 越在上面优先度越高 */
    { NULL,                  NULL,                "保存文件",        0,            1,          0,          0,        -1,      0}, // 浏览器保存文件      浮动
    { NULL,                  NULL,                "图片查看器",      0,            1,          0,          0,        -1,      0}, // qq图片查看器        浮动
    { NULL,                  NULL,                "的聊天记录",      0,            1,          0,          0,        -1,      0}, // qq的聊天记录        浮动
    // { NULL,                  NULL,                "图片查看",        0,            1,          0,          0,        -1,      0}, // 微信图片查看器      浮动
    // { NULL,                  NULL,                "图片预览",        0,            1,          0,          0,        -1,      0}, // 企业微信图片查看器  浮动
    // { NULL,                  NULL,                "Media viewer",   0,            1,          0,          0,        -1,      0}, // tg图片查看器        浮动

    /** 普通优先度 */
    {        NULL,            "qq",                 NULL,             1 << 8,       0,          0,          0,        -1,      0}, // qq         tag -> ﬄ 无边框
    // {"vivaldi-stable",        NULL,                 NULL,             1 << 3,       0,          0,          0,        -1,      0}, // qq         tag -> ﬄ 无边框
    {"scratchpad",    "scratchpad",         "scratchpad",            TAGMASK,       1,          1,          0,        -1,      8}, // scratchpad          浮动、全局、无边框 屏幕顶部
    {      "rofi",            NULL,                 NULL,                  0,       0,          0,          0,        -1,      0}, // obs        tag -> 󰕧
    {  "Snipaste",            NULL,                 NULL,                  0,       1,          0,          1,        -1,      0}, // 火焰截图            浮动
    //{"chrome",               NULL,                 NULL,             1 << 4,       0,          0,          0,        -1,      0}, // chrome     tag -> 
    //{"Vncviewer",            NULL,                 NULL,             0,            1,          0,          1,        -1,      2}, // Vncviewer           浮动、无边框 屏幕顶部

    /** 部分特殊class的规则 */
    {"float",                NULL,                 NULL,             0,            1,          0,          0,        -1,      0}, // class = float       浮动
    {"global",               NULL,                 NULL,             TAGMASK,      0,          1,          0,        -1,      0}, // class = gloabl      全局
    {"noborder",             NULL,                 NULL,             0,            0,          0,          1,        -1,      0}, // class = noborder    无边框
    {"FG",                   NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1,      0}, // class = FG          浮动、全局
    {"FN",                   NULL,                 NULL,             0,            1,          0,          1,        -1,      0}, // class = FN          浮动、无边框
    {"GN",                   NULL,                 NULL,             TAGMASK,      0,          1,          1,        -1,      0}, // CLASS = GN          全局、无边框

    /** 优先度低 越在上面优先度越低 */
    { NULL,                  NULL,                "crx_",            0,            1,          0,          0,        -1,      0}, // 错误载入时 会有crx_ 浮动
    { NULL,                  NULL,                "broken",          0,            1,          0,          0,        -1,      0}, // 错误载入时 会有broken 浮动
};
static const char *overviewtag = "OVERVIEW";
static const Layout overviewlayout = { "󰕳",  overview };

/* 自定义布局 */
static const Layout layouts[] = {
    { "󰙀 ",  tile },         /* 主次栈 */
    { "󰕰",  magicgrid },    /* 网格   */
};

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG, cmd) \
    { MODKEY,              KEY, view,       {.ui = 1 << TAG, .v = cmd} }, \
    { MODKEY|ShiftMask,    KEY, tag,        {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,  KEY, toggleview, {.ui = 1 << TAG} }, \

static Key keys[] = {
    /* modifier            key              function          argument */

    { MODKEY|ShiftMask,    XK_equal,        togglesystray,    {0} },                     /* super shift +      |  切换 托盘栏显示状态 */
    { MODKEY,              XK_j,            focusstack,       {.i = +1} },               /* super j            |  本tag内切换聚焦窗口 */
    { MODKEY,              XK_k,            focusstack,       {.i = -1} },               /* super k            |  本tag内切换聚焦窗口 */
    { MODKEY,              XK_Up,           focusstack,       {.i = -1} },               /* super up           |  本tag内切换聚焦窗口 */
    { MODKEY,              XK_Down,         focusstack,       {.i = +1} },               /* super down         |  本tag内切换聚焦窗口 */
    { Mod1Mask,            XK_Tab,          focusstack,       {.i = +1} },               /* alt tab            |  本tag内切换聚焦窗口 */
    { Mod1Mask|ShiftMask,  XK_Tab,          focusstack,       {.i = -1} },               /* alt shift tab      |  本tag内切换聚焦窗口 */

    { MODKEY,              XK_comma,        viewtoleft,       {0} },                     /* super ,            |  聚焦到左边的tag */
    { MODKEY,              XK_period,       viewtoright,      {0} },                     /* super .            |  聚焦到右边的tag */
    { MODKEY,              XK_Left,         viewtoleft,       {0} },                     /* super left         |  聚焦到左边的tag */
    { MODKEY,              XK_Right,        viewtoright,      {0} },                     /* super right        |  聚焦到右边的tag */
    { MODKEY|ShiftMask,    XK_Left,         tagtoleft,        {0} },                     /* super shift left   |  将本窗口移动到左边tag */
    { MODKEY|ShiftMask,    XK_Right,        tagtoright,       {0} },                     /* super shift right  |  将本窗口移动到右边tag */

    { MODKEY,              XK_Tab,          toggleoverview,   {0} },                     /* super tab          |  显示所有tag 或 跳转到聚焦窗口的tag */

    { MODKEY,              XK_minus,        setmfact,         {.f = -0.05} },            /* super -            |  缩小主工作区 */
    { MODKEY,              XK_equal,        setmfact,         {.f = +0.05} },            /* super =            |  放大主工作区 */

    { MODKEY,              XK_i,            hidewin,          {0} },                     /* super i            |  隐藏 窗口 */
    { MODKEY|ShiftMask,    XK_i,            restorewin,       {0} },                     /* super shift i      |  取消隐藏 窗口 */

    { MODKEY,              XK_d,            zoom,             {0} },                     /* super d            |  将当前聚焦窗口置为主窗口 */

    { MODKEY,              XK_t,            togglefloating,   {0} },                     /* super t            |  开启/关闭 聚焦目标的float模式 */
    { MODKEY|ShiftMask,    XK_t,            toggleallfloating,{0} },                     /* super shift t      |  开启/关闭 全部目标的float模式 */
    { MODKEY,              XK_f,            fullscreen,       {0} },                     /* super f            |  开启/关闭 全屏 */
    { MODKEY|ShiftMask,    XK_f,            togglebar,        {0} },                     /* super shift f      |  开启/关闭 状态栏 */
    { MODKEY,              XK_g,            toggleglobal,     {0} },                     /* super g            |  开启/关闭 全局 */
    { MODKEY|ShiftMask,    XK_u,            toggleborder,     {0} },                     /* super shift u      |  开启/关闭 边框 */
    { MODKEY,              XK_u,            incnmaster,       {.i = +1} },               /* super u            |  改变主工作区窗口数量 (1 2中切换) */

    { MODKEY,              XK_q,            killclient,       {0} },                     /* super q            |  关闭窗口 */
    { MODKEY|ControlMask,  XK_q,            forcekillclient,  {0} },                     /* super ctrl q       |  强制关闭窗口(处理某些情况下无法销毁的窗口) */
    { MODKEY|ControlMask,  XK_F12,          quit,             {0} },                     /* super ctrl f12     |  退出dwm */

    { MODKEY|ShiftMask,    XK_space,        selectlayout,     {.v = &layouts[1]} },      /* super shift space  |  切换到另一个布局 */
    { MODKEY,              XK_o,            showonlyorall,    {0} },                     /* super o            |  切换 只显示一个窗口 / 全部显示 */

    { MODKEY|ControlMask,  XK_equal,        setgap,           {.i = -6} },               /* super ctrl +       |  窗口增大 */
    { MODKEY|ControlMask,  XK_minus,        setgap,           {.i = +6} },               /* super ctrl -       |  窗口减小 */
    { MODKEY|ControlMask,  XK_space,        setgap,           {.i = 0} },                /* super ctrl space   |  窗口重置 */

    { MODKEY|ControlMask,  XK_Up,           movewin,          {.ui = UP} },              /* super ctrl up      |  移动窗口 */
    { MODKEY|ControlMask,  XK_Down,         movewin,          {.ui = DOWN} },            /* super ctrl down    |  移动窗口 */
    { MODKEY|ControlMask,  XK_Left,         movewin,          {.ui = LEFT} },            /* super ctrl left    |  移动窗口 */
    { MODKEY|ControlMask,  XK_Right,        movewin,          {.ui = RIGHT} },           /* super ctrl right   |  移动窗口 */

    { MODKEY|Mod1Mask,     XK_Up,           resizewin,        {.ui = V_REDUCE} },        /* super alt up       |  调整窗口 */
    { MODKEY|Mod1Mask,     XK_Down,         resizewin,        {.ui = V_EXPAND} },        /* super alt down     |  调整窗口 */
    { MODKEY|Mod1Mask,     XK_Left,         resizewin,        {.ui = H_REDUCE} },        /* super alt left     |  调整窗口 */
    { MODKEY|Mod1Mask,     XK_Right,        resizewin,        {.ui = H_EXPAND} },        /* super alt right    |  调整窗口 */

    { MODKEY,              XK_h,            focusdir,         {.i = LEFT } },            /* super h            | 二维聚焦窗口 */
    { MODKEY,              XK_l,            focusdir,         {.i = RIGHT } },           /* super l            | 二维聚焦窗口 */
    { MODKEY|ShiftMask,    XK_k,            exchange_client,  {.i = UP } },              /* super shift k      | 二维交换窗口 (仅平铺) */
    { MODKEY|ShiftMask,    XK_j,            exchange_client,  {.i = DOWN } },            /* super shift j      | 二维交换窗口 (仅平铺) */
    { MODKEY|ShiftMask,    XK_h,            exchange_client,  {.i = LEFT} },             /* super shift h      | 二维交换窗口 (仅平铺) */
    { MODKEY|ShiftMask,    XK_l,            exchange_client,  {.i = RIGHT } },           /* super shift l      | 二维交换窗口 (仅平铺) */

    /*{ MODKEY,              XK_b,            focusmon,         {.i = +1} },                super b            |  光标移动到另一个显示器 */
    /*{ MODKEY|ShiftMask,    XK_b,            tagmon,           {.i = +1} },                super shift b      |  将聚焦窗口移动到另一个显示器 */

    /* spawn + SHCMD 执行对应命令 */
    { MODKEY,              XK_x,      spawn, SHCMD("~/scr/blurlock.sh") },                                                /* super x          | 启动锁屏               */
    { MODKEY,              XK_Return, spawn, SHCMD("alacritty") },                                                        /* super enter      | 打开 alacritty 终端    */
    { MODKEY,              XK_space,  spawn, SHCMD("alacritty --class float") },                                          /* super space      | 打开浮动 alacritty 终端*/
    { MODKEY,              XK_e,      spawn, SHCMD("st -e yazi") },                                                       /* super e          | 打开 yazi              */
    { MODKEY,              XK_b,      spawn, SHCMD("vivaldi") },                                                          /* super b          | 打开 vivaldi           */
    { MODKEY,              XK_a,      spawn, SHCMD("dunstctl history-pop") },                                             /* super a          | 查看上一条通知         */
    { MODKEY|ShiftMask,    XK_a,      spawn, SHCMD("dunstctl close-all") },                                               /* super shift a    | 关闭所有通知           */
    { MODKEY,              XK_s,      spawn, SHCMD("rofi -show drun -matching prefix")},                                  /* super s          | 打开rofi run           */
    { MODKEY,              XK_m,      spawn, SHCMD("~/scr/rofi.sh") },                                                    /* super m          | 自定义脚本             */
    { MODKEY|ShiftMask,    XK_q,      spawn, SHCMD("kill -9 $(xprop | grep _NET_WM_PID | awk '{print $3}')") },           /* super shift q    | 选中某个窗口并强制kill */
    { MODKEY,              XK_n,      togglescratch, SHCMD("st -t scratchpad -g 160x50 -e bash -c 'tmux has-session -t spad && tmux attach -t spad || tmux new-session -s spad'") },                                /* super n          | 打开便携终端 scratchpad*/
    { 0,                   XK_F4,         		    spawn, SHCMD("flameshot gui") },                               /* flameshot        | 截图                   */
    { 0,                   XF86XK_AudioLowerVolume,         spawn, SHCMD("~/scr/vol.sh D 1") },                    /* 音量减按键       | 音量减                 */
    { 0,                   XF86XK_AudioRaiseVolume,         spawn, SHCMD("~/scr/vol.sh U 1") },                    /* 音量加按键       | 音量加                 */
    { 0,                   XF86XK_AudioMute,                spawn, SHCMD("~/scr/vol.sh R 1") },                    /* 静音按键         | 静音                   */
    { Mod1Mask,            XF86XK_AudioLowerVolume,         spawn, SHCMD("~/scr/light.sh D 1") },                  /* 音量减按键       | 音量减                 */
    { Mod1Mask,            XF86XK_AudioRaiseVolume,         spawn, SHCMD("~/scr/light.sh U 1") },                  /* 音量加按键       | 音量加                 */
    { 0,                   XF86XK_MonBrightnessDown,        spawn, SHCMD("~/scr/light.sh D 1") },                  /* 亮度减按键       | 亮度加                 */
    { 0,                   XF86XK_MonBrightnessUp,          spawn, SHCMD("~/scr/light.sh U 1") },                  /* 亮度加按键       | 亮度减                 */
    //{ MODKEY,              XK_w,      spawn, SHCMD("rofi -matching prefix -show window -window-match-fields class") },    /* super w          | 打开 rofi window       */


    /* super key : 跳转到对应tag (可附加一条命令 若目标目录无窗口，则执行该命令) */
    /* super shift key : 将聚焦窗口移动到对应tag */
    /* key tag cmd */
    TAGKEYS(XK_1, 0, 0)
    TAGKEYS(XK_2, 1, 0)
    TAGKEYS(XK_3, 2, 0)
    // TAGKEYS(XK_b, 2, 0)
    TAGKEYS(XK_4, 3, 0)
    TAGKEYS(XK_5, 4, 0)
    TAGKEYS(XK_0, 8, "qq")
};

static Button buttons[] = {
    /* click               event mask       button            function       argument  */
    /* 点击窗口标题栏操作 */
    { ClkWinTitle,         0,               Button1,          hideotherwins, {0} },                                   // 左键        |  点击标题     |  隐藏其他窗口仅保留该窗口
    { ClkWinTitle,         0,               Button3,          togglewin,     {0} },                                   // 右键        |  点击标题     |  切换窗口显示状态
    /* 点击窗口操作 */
    { ClkClientWin,        MODKEY,          Button1,          movemouse,     {0} },                                   // super+左键  |  拖拽窗口     |  拖拽窗口
    { ClkClientWin,        MODKEY,          Button3,          resizemouse,   {0} },                                   // super+右键  |  拖拽窗口     |  改变窗口大小
    /* 点击tag操作 */
    { ClkTagBar,           0,               Button1,          view,          {0} },                                   // 左键        |  点击tag      |  切换tag
    { ClkTagBar,           0,               Button3,          toggleview,    {0} },                                   // 右键        |  点击tag      |  切换是否显示tag
    { ClkTagBar,           MODKEY,          Button1,          tag,           {0} },                                   // super+左键  |  点击tag      |  将窗口移动到对应tag
    { ClkTagBar,           0,               Button4,          viewtoright,   {0} },                                   // 鼠标滚轮上  |  tag          |  向前切换tag
    { ClkTagBar,           0,               Button5,          viewtoleft,    {0} },                                   // 鼠标滚轮下  |  tag          |  向后切换tag
    /* 点击状态栏操作 */
    { ClkStatusText,       0,               Button1,          clickstatusbar,{0} },                                   // 左键        |  点击状态栏   |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal L
    { ClkStatusText,       0,               Button2,          clickstatusbar,{0} },                                   // 中键        |  点击状态栏   |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal M
    { ClkStatusText,       0,               Button3,          clickstatusbar,{0} },                                   // 右键        |  点击状态栏   |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal R
    { ClkStatusText,       0,               Button4,          clickstatusbar,{0} },                                   // 鼠标滚轮上  |  状态栏       |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal U
    { ClkStatusText,       0,               Button5,          clickstatusbar,{0} }                                    // 鼠标滚轮下  |  状态栏       |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal D

    /* 点击bar空白处 */
    // { ClkBarEmpty,         0,               Button1,          spawn, SHCMD("rofi -matching prefix -show window -window-match-fields class") },        // 左键        |  bar空白处    |  rofi 执行 window
    // { ClkBarEmpty,         0,               Button3,          spawn, SHCMD("rofi -show drun -matching prefix") },          // 右键        |  bar空白处    |  rofi 执行 drun
};
