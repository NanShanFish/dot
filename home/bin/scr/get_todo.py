#!/usr/bin/env python

import os
import re
import glob
from datetime import datetime, timedelta
from datetime import time as dt_time
from functools import reduce, partial

BASE_FOLDER = '/home/shan/doc/notes/2-daily/'
TODO_FOLDER = BASE_FOLDER + 'Todo/'

TITLE_RE = re.compile(r"^\** (?!DONE\b)(?:TODO )?([^\n]*)\n")
TYPE_DATETIME_RE = re.compile(
        r"(SCHEDULED|DEADLINE):\s*<(20\d{2}-\d{2}-\d{2})(?: [一二三四五六日])?( \d{1,2}:\d{2})?(?: -(\d{1,2})([dwmy]))?>"
)
NOW = datetime.now()
TODAY = NOW.date()
TIME = NOW.time()
WEEK_DAY = ["一", "二","三","四", "五", "六", "日"]

def f_chain(val, *func):
    return reduce(lambda v, f: f(v), func, val)

def trans2num(date: datetime) -> str:
    return date.year * 12 + date.month

def trans2date(date_num: int) -> datetime:
    year, month = divmod(date_num, 12)
    return datetime(year, month, 1)

def get_dir_org_files(dir_path) -> list[str]:
    if not os.path.isdir(dir_path):
        return []

    return [os.path.join(dir_path, file) for file in os.listdir(dir_path) if file.endswith("org")]

def get_recent_files(
    diary_base: str,
    base_dt: datetime
) -> list[str] :
    diary_files = []
    firstday_of_this_mon_num = trans2num(base_dt)
    for i in [0, -1]:
        tar_date = trans2date(firstday_of_this_mon_num + i)

        year = str(tar_date.year)
        month = "{:02}".format(tar_date.month)

        tar_dir = os.path.join(diary_base, year, month)

        diary_files.extend(get_dir_org_files(tar_dir))
    return diary_files


class Task:
    def __init__(self, task_type, date_obj, time_str, txt, remind_date):
        self.type = task_type   # 'SCH' 或 'DDL'
        self.date = date_obj    # datetime.date 对象
        self.time = time_str    # '10:00' 字符串或 None
        self.txt = txt          # 任务标题
        self.remind_date = remind_date

    def __repr__(self):
        return f"<Task {self.type} {self.date} {self.time} '{self.txt}'>"

_delta_dict = { 'd': 1, 'w': 7, 'm': 30, 'y': 365 }
def _calc_delta(num: int, unit: str) -> timedelta:
    unit = unit.lower()
    return timedelta(days=_delta_dict[unit] * num)

def parse_org_by_chunks_v3(filepath):
    tasks = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        chunks = content.split('\n*')

        for chunk in chunks:
            if not chunk.strip():
                continue

            time_match = TYPE_DATETIME_RE.search(chunk)
            if not time_match:
                continue

            title_match = TITLE_RE.match(chunk)
            if not title_match:
                continue

            raw_type, date_str, time_str, remind_num, unit = time_match.groups()
            txt = title_match.group(1).strip()

            dt = datetime.strptime(date_str, "%Y-%m-%d").date()
            if time_str:
                tm = datetime.strptime(time_str.strip(), "%H:%M").time()
            else:
                tm = None

            if raw_type == "SCHEDULED":
                t_type = "SCH"
                remind_date = dt
            else:
                t_type = "DDL"
                remind_date = dt - _calc_delta(14, 'd')
            if unit:
                remind_date = dt - _calc_delta(int(remind_num), unit)

            tasks.append(Task(t_type, dt, tm, txt, remind_date))

    except (FileNotFoundError, PermissionError):
        return []

    return tasks

def str_title(date: datetime) -> str:
    weekday = WEEK_DAY[date.weekday()-1]
    return date.strftime("%y/%m/%d") + '(' + weekday + ')'

def sort_key(t):
    is_today = 0 if t.date == TODAY else 1
    has_time = 0 if t.time is not None else 1
    time_val = t.time if t.time is not None else dt_time.max
    return (is_today, t.date, has_time, time_val)
def sort_key2(t):
    has_time = 0 if t.time is not None else 1
    time_val = t.time if t.time is not None else dt_time.max
    return (has_time, time_val)

def render(task_list: list[Task]):
    after_week_date = TODAY + timedelta(days=7)
    task_in_week = [t for t in task_list if t.remind_date <= after_week_date]

    print(str_title(TODAY))
    task_today = sorted(
        [t for t in task_in_week if t.remind_date <= TODAY],
        key=sort_key
    )

    flag = 0
    for t in task_today:
        if t.date == TODAY:
            if t.time is not None:
                if t.time > TIME and flag == 0:
                    print(f"  [{TIME.strftime('%H:%M')}] <-- now")
                    flag = 1
                print(f"  [{t.time.strftime('%H:%M')}] {t.txt}")
            else:
                print(f"  [全天] {t.txt}")
        else:
            if t.date > TODAY:
                delta_days = (t.date - TODAY).days
                print(f"  [In {delta_days} d.] {t.txt}")
            else:
                delta_days = (TODAY - t.date).days
                print(f"  [Sched {delta_days} x] {t.txt}")

    for i in range(1,7):
        tar_date = TODAY + timedelta(days=i)
        print(str_title(tar_date))
        t_tmp = sorted([t for t in task_in_week if t.date == tar_date], key=sort_key2)
        for t in t_tmp:
            if t.time is not None:
                print(f"  [{t.time.strftime('%H:%M')}] {t.txt}")
            else:
                print(f"  [全天] {t.txt}")


if __name__ == "__main__":
    target_files = get_dir_org_files(TODO_FOLDER)
    target_files.extend(get_recent_files(BASE_FOLDER, TODAY))

    tasks = []
    for file in target_files:
        tasks.extend(parse_org_by_chunks_v3(file))
    render(tasks)
