# jsp_technique
JSP (프론트엔드는 졸업했고, 백앤드위주입니다) 오해없으시길
쓰기 귀찮지만 그래도 작성해보는 코드


# 🧠 JSP Admin Dashboard Template

> 실무 설계력과 JSP 통합 역량을 증명하는 단일 JSP 관리자 대시보드 예제
이 프로젝트는 JSP 단일 페이지에서 **세션 기반 보안 처리**, **동적 데이터 로딩**, **통계 출력**, **컴포넌트 재사용**, **에러 흐름 처리** 등 **엔터프라이즈 개발자가 실제로 구현하는 기능들을 압축적으로 시연**

---

## ✨ 주요 특징

- ✅ `sessionScope`를 활용한 **세션 인증/권한 체크 로직**
- ✅ `c:choose`, `c:forEach`, `fmt:formatNumber` 등 **JSTL 기반의 렌더링 정석 구현**
- ✅ `List<Map<String, Object>>`를 활용한 **동적 데이터 구조 생성 및 JSP 바인딩**
- ✅ 품절, 활성 상태 등 **비즈니스 로직 기반의 통계 및 조건부 출력**
- ✅ `try-catch` 및 `simulateError`를 통한 **에러 흐름 테스트 시뮬레이션**
- ✅ `jsp:include`로 **header/footer 모듈화 및 페이지 재사용**
- ✅ `DateTimeFormatter` 등 Java 8+의 **모던 API 활용**

---

## 🧱 페이지 구조 요약

```plaintext
📄 adminDashboard.jsp
├── [1] 사용자 인증 및 관리자 권한 확인 (세션 기반)
├── [2] header.jspf / footer.jspf include (재사용 모듈)
├── [3] 데이터 가상 생성 (users, orders, products)
│     └─ 통계 계산 (매출합계, 품절 수, 활성회원 수 등)
├── [4] JSTL로 동적 테이블 렌더링 (3개 섹션)
├── [5] 에러 메시지, info 메시지, simulateError 처리
└── [6] 전체 흐름 출력 및 로그 처리
```

---

## 💻 실행 조건

- JSP 컨테이너 (Tomcat 9+, Jetty 등)
- JDK 8 이상
- JSTL 1.2 라이브러리 포함 (`taglib` 명시됨)

---

## 📊 포함된 대시보드 데이터 예시

- `활성 사용자 수` = ACTIVE 상태인 사용자만 필터링
- `총 매출` = 주문 리스트의 `totalAmount` 합계
- `품절 상품` = stock == 0 인 상품 수
- 사용자 목록 = 동적으로 ID/이름/가입일 렌더링
- 주문 목록 = `items` 배열을 EL로 join 출력
- 상품 목록 = `재고 있음`/`품절` 텍스트 조건 출력

---

## 🧠 왜 이 코드를 모두에게 공개했는가

- 단순한 JSTL 예제가 아니라, **JSP 단일 페이지 안에서 세션 인증 + 데이터 가공 + UI 구성 + 에러 처리까지** 처리됨
- `requestScope`, `sessionScope`, `jsp:include`, `c:choose`, `EL 표현식`, `java.util + java.time` 조합까지 **실전형 JSP 패턴의 집약체**
- “실무 프로젝트에서 어떤 JSP를 만들어야 하는지”에 대한 기준점 제시해봄. 저 혼자 생각입니다 :)

---

## 📦 예시 실행 화면 (텍스트 기반 요약)

```plaintext
[환영합니다, admin (역할: ADMIN)] [로그아웃]

✅ 활성 사용자: 2
✅ 총 매출: ₩180,000
✅ 품절 상품: 1

[사용자 목록] [주문 목록] [상품 재고 목록]
```

---

## 📁 폴더 구성 예시 (추천 구조)

```
├── adminDashboard.jsp          # 메인 JSP 파일
├── WEB-INF/
│   └── jspf/
│       ├── header.jspf         # 공통 헤더 모듈
│       └── footer.jspf         # 공통 푸터 모듈
├── login.jsp                   # 로그인 페이지 (리다이렉트용)
├── error.jsp                   # 에러 메시지 출력용
```

---

## 🛠 권장 확장 방향

- 실제 DAO/Service 연결 구조로 이식
- Spring MVC 기반 구조로 컨트롤러/뷰 분리
- JSP 내 Java 코드 제거하고 JSP는 뷰 전용으로 전환

---

## 📜 라이선스

MIT License

---

## 🙋‍♂️ Author
by K.H CHOI
> JSP 기반 관리 페이지의 정석 구조를 학습하거나 벤치마킹할 수 있는 예시로 활용 가능하시면 해보시고,  AS는 직접하세요.
>
> 
