import os
import pytest
import pynvim
import shutil
import tempfile


ARGV = ["nvim", "-u", "init.vim", "--headless", "--embed"]


ROOT = {
    "d-1": {
        "d-1-1": {
            "d-1-1-1": {},
        },
        "d-1-2": {},
        "d-1-3": {
            "d-1-3-1": {},
            "d-1-3-2": {},
        },
        "d-1-4": {
            "f-1": "d-1-4-f-1",
        },
        "a-1": "d-1-f-1",
        "b-2": "d-1-f-2",
        "c-3": "d-1-f-3",
    },
    "d-2": {
        "d-2-1": {},
        "d-2-2": {},
    },
    "d-3": {},
    "z-4": {
        "z-4-1": {
            "z-4-1-1": {},
            "z-4-1-2": {},
        },
        "z-4-2": {
            "z-4-2-1": {},
        },
        "z-4-5": {
            "z-4-5-1": {},
        },
    },
    "a-1": "a-1",
    "b-1": "b-1",
    "z-1": "z-1"
}


def fwrite(path, content):
    with open(path, "w") as fd:
        fd.write(content)


def mkdir(parent, subtree):
    os.mkdir(parent)
    for k, v in subtree.items():
        if isinstance(v, (dict,)):
            mkdir(os.path.join(parent, k), v)
        elif isinstance(v, (str,)):
            fwrite(os.path.join(parent, k), v)


@pytest.fixture(scope="session")
def fsroot(request):
    tmp = os.path.join(tempfile.gettempdir(), "fstree")

    def fin():
        shutil.rmtree(tmp, ignore_errors=False, onerror=None)

    request.addfinalizer(fin)

    mkdir(tmp, ROOT)
    return tmp

@pytest.fixture(scope="session")
def nvim(request, fsroot):
    nvim = pynvim.attach("child", argv=ARGV)
    request.addfinalizer(nvim.close)
    nvim.command(f"lcd {fsroot}")
    return nvim


@pytest.fixture
def fsbuf(request, nvim, fsroot):
    nvim.command("FsTreeOpen")
    return nvim.current.buffer
