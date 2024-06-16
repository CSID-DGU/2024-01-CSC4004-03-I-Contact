# 🍱 LOIO (LeftOver Is Over)

## 프로젝트 소개
📌 많은 양의 음식물 쓰레기는 환경 오염의 주요 원인 중 하나입니다. 
이에 우리는 음식물쓰레기의 발생을 줄일 방법에 대해 고민했고 OSS를 활용한 모바일 애플리케이션을 개발하게 되었습니다.

✔︎ 점주는 점주용 애플리케이션에 매장을 등록하고 매장 마감 전 미리 준비해뒀으나 판매하지 못해서 폐기해야하는 음식을 기존 가격보다 할인된 가격에 판매할 수 있습니다.

✔︎ 고객용 애플리케이션을 사용하는 소비자들은 주변에 있는 가게들의 남은 음식의 정보를 확인하고 저렴하게 구매할 수 있습니다. 

🙏 Loio의 이용자가 늘어날수록 음식물 쓰레기의 발생은 줄어들 환경 보호를 향한 작지만 큰 걸음을 내딛을 수 있습니다.

## 다운로드
- 고객 어플리케이션 <br>
[![Customer Application](https://img.shields.io/badge/Download_For_Customers-blue?style=for-the-badge&logo=Android)](https://drive.google.com/file/d/1itznIU5npvExpNon0nxaK6zrr0sbhfWT/view?usp=drive_link)
- 점주 어플리케이션 <br>
[![Owner Application](https://img.shields.io/badge/Download_For_Owners-green?style=for-the-badge&logo=Android)](https://drive.google.com/file/d/1MrhUM7Ys6eChTPpwzd0FnKz653oth-Cy/view?usp=drive_link)
- 설치 후 설정에서 알림을 허용해주세요
- 현재는 안드로이드만 지원합니다



## 개발 환경
- 개발도구 <br>
![VS Code](https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white) ![IntelliJ IDEA](https://img.shields.io/badge/IntelliJ_IDEA-000000?style=for-the-badge&logo=intellij-idea&logoColor=white)
- 협업도구 <br>
![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white) ![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white) ![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white) ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)
- 어플리케이션 <br>
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
- 서버 <br>
![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white) ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

## 시스템 구성도
![Diagram](https://github.com/CSID-DGU/2024-01-CSC4004-03-I-Contact/blob/main/Doc/%EA%B5%AC%EC%84%B1%EB%8F%84.png?raw=true)

이 시스템 구성도는 LOIO 프로젝트의 전체 시스템을 나타냅니다. 시스템은 크게 Client와 Server로 구성됩니다.

- Client
	- 고객 어플리케이션: 사용자는 이 앱을 통해 주변 가게들의 남은 음식 정보를 확인하고 구매할 수 있습니다.
	- 점주 어플리케이션: 점주는 이 앱을 통해 매장을 등록하고 남은 음식을 할인된 가격에 판매할 수 있습니다.

- Azure Web Apps
	- 백엔드 어플리케이션이 배포되는 클라우드 서비스입니다.
	- Spring Boot 어플리케이션이 실행됩니다.

- Spring Boot
	- API 서버로, 클라이언트의 요청을 처리하고 데이터베이스와의 상호작용, 사용자 인증, 알림 전송 등의 기능을 수행합니다.
	- WebSocket의 STOMP 프로토콜을 사용하여 주문목록, 메뉴현황 등에 실시간 데이터 업데이트를 지원합니다. 

- Firebase
	- Google 로그인시 사용자 인증을 관리합니다.
	- Cloud Messaging 서비스를 통해 Spring Boot 어플리케이션에서 클라이언트 어플리케이션으로 푸시 알림을 전송하는데 사용됩니다. 주문이 등록되거나 즐겨찾기한 식당이 판매개시하는 경우 알림이 전송됩니다.


## 팀원 구성
|윤진수|남상원|서지민|안하현|염경민|
|:---:|:---:|:---:|:---:|:---:|
|서버|고객앱|점주앱|고객앱|점주앱|
|<img src="https://avatars.githubusercontent.com/u/51525934?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/139528469?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/129031753?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/150058057?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/153171942?v=4" width="150" height="150"/>|
|Jinsoo Yoon<br/>[@floreo1242](https://github.com/floreo1242)|[@DavyScar](https://github.com/DavyScar)|[@seojm07](https://github.com/seojm07)|ha-hyeon<br/>[@ha-hyeon](https://github.com/ha-hyeon)|[@Ykmykmkkk](https://github.com/Ykmykmkkk)|

## 라이선스

이 프로젝트는 [MIT 라이선스](LICENSE) 하에 배포됩니다. 자세한 내용은 [LICENSE 파일](LICENSE)을 참조하세요.

