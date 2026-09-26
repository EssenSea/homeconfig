import os
import subprocess
import sys

import requests

from sioyek.sioyek import Sioyek, clean_path


def get_secret(name: str) -> str:
    """调用 pass 后台静默取密钥，失败抛异常。"""
    return subprocess.check_output(
        ["pass", "show", name],
        text=True,
        stderr=subprocess.DEVNULL,
    ).strip()


DEEPSEEK_API_URL = "https://api.deepseek.com/v1/chat/completions"


if __name__ == "__main__":
    # 1. 先取密钥，失败则直接退出，避免后面 KeyError
    try:
        dsapi = get_secret("deepseek")
    except Exception as e:
        print(f"Failed to fetch secret: {e}", file=sys.stderr)
        sys.exit(1)

    sioyek_path = clean_path(sys.argv[1])
    text = sys.argv[2]
    sioyek = Sioyek(sioyek_path)

    headers = {
        "Authorization": f"Bearer {dsapi}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": "deepseek-chat",
        "messages": [
            {
                "role": "system",
                "content": "You are a translator. Translate the following text to Chinese. "
                           "Return only the translation without any explanation.",
            },
            {"role": "user", "content": text},
        ],
        "temperature": 0.3,
    }

    try:
        response = requests.post(DEEPSEEK_API_URL, json=payload, headers=headers)
        response.raise_for_status()
        translation = response.json()["choices"][0]["message"]["content"]
    except Exception as e:
        translation = f"Translation failed: {e}"

    sioyek.set_status_string(translation)
