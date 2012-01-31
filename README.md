# Overview

HTTP 테스트나 개발용도로 간단한 프록시 서버가 필요할 때 사용할만한 루비 스크립트입니다. EventMachine을 이용해서 만들었습니다.
 
# 소스코드
* http://github.com/hatemogi/em_http_proxy/blob/master/proxy.rb
 
# 스크립트 실행환경

* ruby 1.8+
* eventmachine 설치 

# 스크립트 실행방법

    sudo gem install eventmachine
    curl -s https://raw.github.com/hatemogi/em_http_proxy/master/proxy.rb | ruby

* 위와같이 실행하면 9000번 포트에 HTTP 프록시 서버가 준비됩니다.
* eventmachine 설치는 처음 한번만 하면 되겠죠.
 
# 외부네트워크 접근불가능한 서버에서 프록시 연결 예제


    curl -sx 192.0.0.0:9000 http://www.google.com

* 192.0.0.0 IP를 위에서 스크립트를 실행한 "외부네트워크와 연결가능한 시스템"의 IP로 바꾸어 적습니다.
* 이 커맨드는 curl에 http_proxy주소를 주어서 http://www.google.com/를 가져오는 커맨드 예제입니다.

# 그 외 활용예

외부 접근 불가능한 서버에서 yum 패키지 인스톨

    export http_proxy=http://192.0.0.0:9000/
    sudo yum install gcc


 
