import os
import pytest
import pynvim
import shutil
import tempfile


ARGV = ["nvim", "-u", "init.vim", "--headless", "--embed"]


@pytest.fixture
def nvim(request, testdir):
    nvim = pynvim.attach("child", argv=ARGV)
    request.addfinalizer(nvim.close)
    nvim.command(f"lcd {testdir}")
    return nvim

@pytest.fixture
def testdir(request):
    tmp = tempfile.gettempdir()

    tmp = os.path.join(tmp, "fstree")
    os.mkdir(tmp)

    os.mkdir(os.path.join(tmp, "d-1"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-1"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-1", "d-1-1-1"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-2"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-3"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-3", "d-1-3-1"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-3", "d-1-3-2"))
    os.mkdir(os.path.join(tmp, "d-1", "d-1-4"))

    os.mkdir(os.path.join(tmp, "d-2"))
    os.mkdir(os.path.join(tmp, "d-2", "d-2-1"))
    os.mkdir(os.path.join(tmp, "d-2", "d-2-2"))

    os.mkdir(os.path.join(tmp, "d-3"))

    os.mkdir(os.path.join(tmp, "d-4"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-1"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-1", "d-4-1-1"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-1", "d-4-1-2"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-2"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-2", "d-4-2-1"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-5"))
    os.mkdir(os.path.join(tmp, "d-4", "d-4-5", "d-4-5-1"))

    def fin():
        shutil.rmtree(tmp, ignore_errors=False, onerror=None)
    
    request.addfinalizer(fin)

    return tmp
