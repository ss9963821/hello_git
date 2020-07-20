< GIT 사용법 >

1. git-repository 폴더에서 git-bash 열기
2. git-init
3. git remote add origin https://github.com/ss9963821/hello_git.git
4. git add .
5. git commit -m test(메세지문구 작성)
6. git push origin master
7. git pull origin master

git fetch : pull 전에 변경사항 확인
git status : 상태 확인
내용 변경해주고,
git add .
git commit -m test(메세지문구 작성)
git push origin master(또는 branch이름)

push 전에 먼저 pull을 해서 프로젝트를 병합해줘야 함.
$ git pull origin woongs --allow-unrelated-histories(강제로 pull)
-- 이미 존재하는 두 프로젝트의 기록(history)을 저장하는 드문 상황에 사용된다고 한다.
-- 즉, git에서는 서로 관련 기록이 없는 이질적인 두 프로젝트를 병합할 때 기본적으로 거부하는데, 이것을 허용해 주는 것이다.


**branch 생성
git chechout -b woongs
git push origin woongs
git branch --set-upstream-to origin/woongs

git push origin master(또는 branch이름)

*** git pull = git fetch + git merge
