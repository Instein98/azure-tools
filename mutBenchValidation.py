import sys, re, shutil
import subprocess as sp
from pathlib import Path

d4jProjPath = Path('d4jProj').resolve()
assert d4jProjPath.exists()
logDirPath = (Path.home() / 'output').resolve()
logDirPath.mkdir(exist_ok=True)
d4jPath = Path('defects4j').resolve()

def modifyD4j():
    targetFilePath = d4jPath / 'framework/projects/defects4j.build.xml'
    assert targetFilePath.exists()
    shutil.copy(str(targetFilePath), str(targetFilePath) + '.bak')
    lineCnt = 0
    content = ''
    with targetFilePath.open() as f:
        for line in f:
            lineCnt += 1
            if lineCnt == 107:
                print('line before modification: ' + line)
                line = line.replace('haltonfailure="no"', 'haltonfailure="yes"')
                print('line before modification: ' + line)
            content += line
    with targetFilePath.open(mode='w') as f:
        f.write(content)
    sp.run('diff -s {} {}'.format(str(targetFilePath), str(targetFilePath) + '.bak'), shell=True, universal_newlines=True, check=False)

def err(msg: str):
    print('[ERROR] ' + msg)

def warn(msg: str):
    print('[WARNING] ' + msg)

def info(msg: str):
    print('[INFO] ' + msg)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        err('Need only one argument as patch file. Patch file name should be "subjectName-mutantId-patchId"')
        exit(1)
    
    modifyD4j()

    patchFilePath = Path(sys.argv[1])
    assert patchFilePath.exists()
    patchFileName = patchFilePath.stem
    [aprName, projName, mid, pid] = patchFileName.split('-')

    targetFileAbsPathInDiff = None
    projPath = d4jProjPath / projName
    with patchFilePath.open() as f:
        for line in f:
            if line.startswith('---'):
                targetFileAbsPathInDiff = line.split()[1]
                m = re.match(r'.*/' + projName + r'-\d+f/(.*java)', targetFileAbsPathInDiff)
                assert m is not None
                javaFileToBeReplacedPath = Path(m[1])
                break
    targetFile = javaFileToBeReplacedPath.stem  # xxx.java
    targetDir = projPath / str(javaFileToBeReplacedPath.parent)
    targetFileAbsPath = projPath / str(javaFileToBeReplacedPath)
    # Applying the patch
    # print('patch -b < {}'.format(str(patchFilePath)) + " at " + str(targetDir))
    sp.run('patch -b < {}'.format(str(patchFilePath)), shell=True, check=True, cwd=str(targetDir), universal_newlines=True)

    try:
        logFileName = patchFileName + '.log'
        logFilePath = logDirPath / logFileName
        with logFilePath.open(mode='w') as f:
            process = sp.Popen('defects4j test'.split(), shell=False, cwd=str(projPath), stderr=f, stdout=f, universal_newlines=True)
            process.wait()
            rtCode = process.poll()
            info('Patch {} finished validation with return code {}'.format(patchFileName, rtCode))
    finally:
        # Recovering the patch
        try:
            sp.run('patch -R < {}'.format(str(patchFilePath)), shell=True, check=True, cwd=str(targetDir), universal_newlines=True)
        except:
            import traceback
            traceback.print_exc()
            warn('Command "{}" failed, now try "{}"'.format('patch -R < {}'.format(str(patchFilePath)), 'cp {} {}'.format(targetFile + '.orig', targetFile)))
            try:
                sp.run('cp {} {}'.format(javaFileToBeReplacedPath.name + '.orig', javaFileToBeReplacedPath.name).split(), shell=False, check=True, cwd=str(targetDir), universal_newlines=True)
            except:
                import traceback
                traceback.print_exc()
                warn('Command "{}" failed, now try "{}"'.format('cp {} {}'.format(targetFile + '.orig', targetFile), "git checkout -- ."))
                sp.run('git checkout -- .', shell=True, check=True, cwd=str(projPath), universal_newlines=True)
    
    
