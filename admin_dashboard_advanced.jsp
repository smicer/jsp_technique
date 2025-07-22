<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.io.IOException" %>

<%--
    17년차 JSP 백엔드 개발자의 하이레벨 역량을 보여주는 샘플 코드

    이 페이지는 단순한 데이터 출력을 넘어, 실제 엔터프라이즈 환경에서 요구되는
    보안, 데이터 처리, 오류 관리, 그리고 UI 통합 능력을 JSP 단일 페이지 내에서
    최대한 압축적으로 보여줍니다.

    핵심 강조 포인트:
    1.  세션 기반의 사용자 인증 및 권한 확인 (보안)
    2.  JSTL 및 EL을 활용한 스크립틀릿 최소화 (모범 사례)
    3.  가상의 백엔드 서비스/DAO 연동 시뮬레이션
    4.  복잡한 데이터 구조를 동적으로 처리 및 표시
    5.  견고한 예외 처리 및 사용자 친화적 메시징
    6.  재사용 가능한 컴포넌트(Header/Footer) 포함

    실제 프로젝트에서는 컨트롤러(Servlet/Spring Controller)에서 데이터를 준비하여
    JSP로 포워딩하는 것이 권장됩니다. 이 코드는 JSP 페이지 내에서 직접 처리하는
    방식으로 "모든 것을 포함"시켜 경력과 역량을 집약적으로 보여줍니다.
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고급 관리자 대시보드 - 17년차 개발자 포트폴리오</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f4f7f6; color: #333; }
        .container { width: 90%; margin: 20px auto; background-color: #fff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); padding: 30px; }
        h1, h2 { color: #2c3e50; border-bottom: 2px solid #e0e0e0; padding-bottom: 10px; margin-bottom: 20px; }
        .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background-color: #f9f9f9; border: 1px solid #eee; border-radius: 5px; padding: 20px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.03); }
        .card h3 { color: #3498db; margin-top: 0; }
        .card p { font-size: 1.8em; font-weight: bold; color: #555; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px 15px; text-align: left; }
        th { background-color: #f2f2f2; color: #444; font-weight: 600; }
        tr:nth-child(even) { background-color: #f8f8f8; }
        tr:hover { background-color: #f0f0f0; }
        .error-message { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px; margin-bottom: 20px; font-weight: bold; }
        .info-message { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .auth-status { text-align: right; margin-bottom: 20px; font-size: 0.9em; color: #666; }
        .logout-button { background-color: #e74c3c; color: white; padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; }
        .logout-button:hover { background-color: #c0392b; }
    </style>
</head>
<body>

    <%-- ===== 1. 보안: 사용자 인증 및 권한 확인 (세션 관리) ===== --%>
    <%
        // 가상 로그인 상태 확인 (실제는 DB 또는 SSO 연동)
        // 세션에서 사용자 ID를 가져옴. 없으면 로그인하지 않은 것으로 간주.
        String userId = (String) session.getAttribute("loggedInUserId");
        String userRole = (String) session.getAttribute("userRole"); // 가상 사용자 역할

        boolean isAuthenticated = (userId != null && !userId.isEmpty());
        boolean hasAdminAccess = isAuthenticated && "ADMIN".equalsIgnoreCase(userRole);

        if (!isAuthenticated) {
            // 로그인 페이지로 리다이렉트 (실제라면 로그인 URL로)
            response.sendRedirect("login.jsp?redirect=" + request.getRequestURI());
            return; // 이후 코드 실행 중단
        }

        // 관리자 권한이 없으면 접근 거부
        if (!hasAdminAccess) {
            request.setAttribute("errorMessage", "접근 권한이 없습니다. 관리자만 이용 가능합니다.");
            // 오류 페이지로 포워딩하거나 간단한 메시지 표시 후 종료
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // 로깅 (실제는 Log4j, SLF4j 등 사용)
        System.out.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) +
                           " [INFO] " + userId + " 님이 관리자 대시보드에 접근했습니다.");
    %>

    <%-- ===== 2. 공통 헤더 포함 (모듈화 및 재사용성) ===== --%>
    <jsp:include page="WEB-INF/jspf/header.jspf">
        <jsp:param name="pageTitle" value="관리자 대시보드"/>
    </jsp:include>
    <%--
        header.jspf (예시 내용):
        <header style="background-color:#2c3e50; color:white; padding:15px 30px;">
            <h1>${param.pageTitle}</h1>
            <nav><a href="#">홈</a> | <a href="#">설정</a></nav>
        </header>
    --%>

    <div class="container">
        <div class="auth-status">
            안녕하세요, <strong style="color: #3498db;">${sessionScope.loggedInUserId}</strong>님! (역할: ${sessionScope.userRole})
            <a href="logout.jsp" class="logout-button">로그아웃</a>
        </div>

        <%-- ===== 3. 예외 처리 및 사용자 피드백 ===== --%>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="error-message">
                <strong>오류 발생:</strong> <c:out value="${requestScope.errorMessage}"/>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.infoMessage}">
            <div class="info-message">
                <strong>알림:</strong> <c:out value="${requestScope.infoMessage}"/>
            </div>
        </c:if>

        <h1>관리자 대시보드</h1>

        <%-- ===== 4. 가상 백엔드 데이터 로딩 및 처리 ===== --%>
        <%
            // 실제로는 Servlet/Spring Controller에서 DB 또는 서비스 계층을 통해 데이터를 가져옴
            // 여기서는 17년차 개발자의 "전천후" 능력을 보여주기 위해 JSP 내에서 가상 데이터 생성.
            // 실제라면 DAO (Data Access Object)를 통해 DB에서 데이터를 가져오는 구조를 사용.
            List<Map<String, Object>> users = new ArrayList<>();
            List<Map<String, Object>> orders = new ArrayList<>();
            List<Map<String, Object>> products = new ArrayList<>();

            // 예외 발생 시나리오 시뮬레이션
            boolean simulateError = (request.getParameter("simulateError") != null);
            if (simulateError) {
                // RuntimeException 발생을 시뮬레이션하여 JSP의 errorPage 속성 또는 try-catch를 보여줌
                throw new RuntimeException("데이터베이스 연결 실패를 시뮬레이션합니다. 잠시 후 다시 시도해주세요.");
            }

            try {
                // --- 가상 사용자 데이터 (DB에서 가져온다고 가정) ---
                users.add(new HashMap<String, Object>() {{
                    put("id", 101); put("name", "김철수"); put("email", "kim@example.com"); put("status", "ACTIVE"); put("registeredAt", "2023-01-15");
                }});
                users.add(new HashMap<String, Object>() {{
                    put("id", 102); put("name", "이영희"); put("email", "lee@example.com"); put("status", "INACTIVE"); put("registeredAt", "2023-03-20");
                }});
                users.add(new HashMap<String, Object>() {{
                    put("id", 103); put("name", "박민수"); put("email", "park@example.com"); put("status", "ACTIVE"); put("registeredAt", "2024-02-01");
                }});

                // --- 가상 주문 데이터 (복잡한 데이터 조인/변환 가정) ---
                orders.add(new HashMap<String, Object>() {{
                    put("orderId", "ORD001"); put("userId", 101); put("totalAmount", 125000.0); put("status", "COMPLETED"); put("orderDate", "2024-07-01");
                    put("items", Arrays.asList("상품A (2)", "상품B (1)"));
                }});
                orders.add(new HashMap<String, Object>() {{
                    put("orderId", "ORD002"); put("userId", 103); put("totalAmount", 55000.0); put("status", "PENDING"); put("orderDate", "2024-07-05");
                    put("items", Arrays.asList("상품C (1)"));
                }});

                // --- 가상 상품 데이터 ---
                products.add(new HashMap<String, Object>() {{
                    put("productId", "PROD001"); put("name", "프리미엄 키보드"); put("price", 80000.0); put("stock", 150);
                }});
                products.add(new HashMap<String, Object>() {{
                    put("productId", "PROD002"); put("name", "무선 마우스"); put("price", 25000.0); put("stock", 0); // 품절
                }});
                products.add(new HashMap<String, Object>() {{
                    put("productId", "PROD003"); put("name", "고해상도 모니터"); put("price", 350000.0); put("stock", 50);
                }});

                // 요청 스코프에 데이터 저장 (JSTL 및 EL로 접근 가능)
                request.setAttribute("userList", users);
                request.setAttribute("orderList", orders);
                request.setAttribute("productList", products);

                // 대시보드 요약 데이터 계산
                int activeUsers = (int) users.stream().filter(u -> "ACTIVE".equals(u.get("status"))).count();
                double totalRevenue = orders.stream().mapToDouble(o -> (Double) o.get("totalAmount")).sum();
                int outOfStockProducts = (int) products.stream().filter(p -> (Integer) p.get("stock") == 0).count();

                request.setAttribute("activeUsersCount", activeUsers);
                request.setAttribute("totalRevenue", totalRevenue);
                request.setAttribute("outOfStockProductsCount", outOfStockProducts);

                System.out.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) +
                                   " [INFO] 대시보드 데이터 성공적으로 로드 및 계산 완료.");

            } catch (Exception e) {
                // JSP 페이지 내에서 발생한 치명적 오류 처리
                request.setAttribute("errorMessage", "데이터를 로드하는 중 심각한 오류가 발생했습니다: " + e.getMessage());
                // 실제 환경에서는 이 오류를 로깅 시스템(Log4j 등)에 전파.
                System.err.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) +
                                   " [CRITICAL] 데이터 로딩 중 예외 발생: " + e.getMessage());
                e.printStackTrace(); // 개발 환경에서만 사용, 프로덕션에서는 상세 스택 트레이스 노출 X
            }
        %>

        <h2>요약 통계</h2>
        <div class="dashboard-grid">
            <div class="card">
                <h3>활성 사용자</h3>
                <p>${activeUsersCount}</p>
            </div>
            <div class="card">
                <h3>총 매출</h3>
                <p><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₩"/></p>
            </div>
            <div class="card">
                <h3>품절 상품</h3>
                <p>${outOfStockProductsCount}</p>
            </div>
        </div>

        <h2>최근 사용자 목록</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>상태</th>
                    <th>가입일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty userList}">
                        <c:forEach var="user" items="${userList}">
                            <tr>
                                <td><c:out value="${user.id}"/></td>
                                <td><c:out value="${user.name}"/></td>
                                <td><c:out value="${user.email}"/></td>
                                <td><c:out value="${user.status}"/></td>
                                <td><c:out value="${user.registeredAt}"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="5">사용자 데이터가 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <h2>최근 주문 목록</h2>
        <table>
            <thead>
                <tr>
                    <th>주문 ID</th>
                    <th>사용자 ID</th>
                    <th>총 금액</th>
                    <th>상태</th>
                    <th>주문일</th>
                    <th>주문 상품</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty orderList}">
                        <c:forEach var="order" items="${orderList}">
                            <tr>
                                <td><c:out value="${order.orderId}"/></td>
                                <td><c:out value="${order.userId}"/></td>
                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₩"/></td>
                                <td><c:out value="${order.status}"/></td>
                                <td><c:out value="${order.orderDate}"/></td>
                                <td>
                                    <c:forEach var="item" items="${order.items}" varStatus="loop">
                                        <c:out value="${item}"/>${!loop.last ? ', ' : ''}
                                    </c:forEach>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="6">주문 데이터가 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <h2>상품 재고 현황</h2>
        <table>
            <thead>
                <tr>
                    <th>상품 ID</th>
                    <th>상품명</th>
                    <th>가격</th>
                    <th>재고</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty productList}">
                        <c:forEach var="product" items="${productList}">
                            <tr>
                                <td><c:out value="${product.productId}"/></td>
                                <td><c:out value="${product.name}"/></td>
                                <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₩"/></td>
                                <td><c:out value="${product.stock}"/></td>
                                <td>
                                    <c:if test="${product.stock == 0}">
                                        <span style="color: red; font-weight: bold;">품절</span>
                                    </c:if>
                                    <c:if test="${product.stock > 0}">
                                        <span style="color: green;">재고 있음</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="5">상품 데이터가 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <%-- ===== 5. 공통 푸터 포함 (모듈화 및 재사용성) ===== --%>
    <jsp:include page="WEB-INF/jspf/footer.jspf" />
    <%--
        footer.jspf (예시 내용):
        <footer style="text-align:center; padding:20px; background-color:#ecf0f1; color:#7f8c8d; margin-top:30px;">
            <p>&copy; ${2024} 17년차 개발자 포트폴리오. All rights reserved.</p>
        </footer>
    --%>

</body>
</html>
