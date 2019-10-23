import pytest
import pynvim


ARGV = ["nvim", "-u", "init.vim", "--headless", "--embed"]


@pytest.fixture
def nvim(request):
    nvim = pynvim.attach("child", argv=ARGV)
    request.addfinalizer(nvim.close)
    return nvim
