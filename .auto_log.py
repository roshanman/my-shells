# coding=utf-8

from HMLogan import HuamiLogan
import sys

logan = HuamiLogan(sys.argv[1], b"sCVR2miVJwi9QPdD", b"pSWPKvl2ND74ZwJI")
res = logan.output_log(errors='ignore')