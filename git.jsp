< GIT 사용법 >

1. git-repository 폴더에서 git-bash 열기
2. git-init
3. git remote add origin https://github.com/ss9963821/hello_git.git
4. git add .
5. git commit -m test(메세지문구 작성)
6. git push origin master
7. git pull origin master
git
git fetch : pull 전에 변경사항 확인
git status : 상태 확인
내용 변경해주고,
git add .
git commit -m test(메세지문구 작성)
git push origin master(또는 branch이름)

** git log --graph : 커밋한 목록 확인
** git show : 커밋에 변경 내용이 반영되었는지 확인

push 전에 먼저 pull을 해서 프로젝트를 병합해줘야 함.
  $ git pull origin woongs --allow-unrelated-histories(강제로 pull)
  -- 이미 존재하는 두 프로젝트의 기록(history)을 저장하는 드문 상황에 사용된다고 한다.
  -- 즉, git에서는 서로 관련 기록이 없는 이질적인 두 프로젝트를 병합할 때 기본적으로 거부하는데, 이것을 허용해 주는 것이다.


** branch 생성
  git branch : 현재 어느 브랜치에 있는지 알 수 있음.
  git checkout -b woongs
  git push origin woongs
  git branch --set-upstream-to origin/woongs : git pull no tracking info 에러해결

  git push origin master(또는 branch이름)

*** git pull = git fetch + git merge
*** git branch -r : 원격 브랜치 목록보기
  git branch -a : 로컬 브랜치 목록보기
  git branch -d branch_name : 브랜치 삭제하기
** git diff [commit이름] [commit이름]

** git merge : 브랜치 개발한 것 병합
 -> master 브랜치로 이동한 뒤에 merge 해야함.
 git checkout master
 git merge woongs : woong 브랜치를 master에 병합.

** git stash : 변경사항 임시저장
 git stash list : 스태시 목록
 git stash pop : 꺼내올때(스택처럼 쌓여있음)

** git log master..woongs  // 마스터 대비 woongs 브랜치의 변경사항을 커밋별로 확인

***GOJGJOGJOGJGo
