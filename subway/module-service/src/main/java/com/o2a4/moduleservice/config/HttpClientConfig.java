package com.o2a4.moduleservice.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.BufferingClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.client.RestTemplate;
import org.apache.http.impl.client.HttpClientBuilder;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

@Slf4j
@RequiredArgsConstructor
@Configuration
@EnableScheduling
public class HttpClientConfig  {
    private static final int MAX_CONNECTIONS_PER_ROUTE = 20;
    private static final int MAX_CONNECTIONS_TOTAL = 200;

    private static final int IDLE_TIMEOUT = 30 * 1000;

    // https://tweety1121.tistory.com/entry/Spring-restTemplate-Connection-pool-%EC%82%AC%EC%9A%A9
    // https://www.hyoyoung.net/103
    @Bean
    public CloseableHttpClient httpClient() {
        return HttpClients.custom()
                .build();
    }

    @Bean
    public PoolingHttpClientConnectionManager poolingHttpClientConnectionManager() {
        PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        connectionManager.setDefaultMaxPerRoute(MAX_CONNECTIONS_PER_ROUTE);
        connectionManager.setMaxTotal(MAX_CONNECTIONS_TOTAL);
        return connectionManager;
    }

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder restTemplateBuilder) {
        // connection pool 적용
        CloseableHttpClient httpClient = HttpClientBuilder.create()
                .setMaxConnTotal(200)   //연결을 유지할 최대 숫자
                .setMaxConnPerRoute(100)  //특정 경로당 최대 숫자
                .setConnectionTimeToLive(5, TimeUnit.SECONDS)   // keep - alive
                .build();

        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
//        factory.setReadTimeout(5000); // 읽기시간초과, ms
//        factory.setConnectTimeout(3000); // 연결시간초과, ms
        factory.setHttpClient(httpClient); // HttpClient 세팅

        BufferingClientHttpRequestFactory bufferingClientHttpRequestFactory = new BufferingClientHttpRequestFactory(factory);


        return restTemplateBuilder
                .requestFactory(() -> bufferingClientHttpRequestFactory)
                .setConnectTimeout(Duration.ofSeconds(5)) //읽기시간초과, ms
                .setReadTimeout(Duration.ofSeconds(5))    //연결시간초과, ms
//                .additionalInterceptors(new RequestResponseLoggingInterceptor())
//                .errorHandler(new RestResponseErrorHandler()) // ResponseErrorHandler interface
                .build();
    }

    @Bean
    public Runnable idleConnectionMonitor(final PoolingHttpClientConnectionManager connectionManager) {
        return new Runnable() {
            @Override
            @Scheduled(fixedDelay = 30 * 1000)
            public void run() {
                try {
                    if (connectionManager != null) {
                        log.debug("{} : 만료 또는 Idle 커넥션 종료.", Thread.currentThread().getName());
                        connectionManager.closeExpiredConnections();
                        connectionManager.closeIdleConnections(IDLE_TIMEOUT, TimeUnit.MILLISECONDS);
                    } else {
                        log.info("{} : ConnectionManager가 없습니다.", Thread.currentThread().getName());
                    }
                } catch (Exception e) {
                    log.error(Thread.currentThread().getName() + " : 만료 또는 Idle 커넥션 종료 중 예외 발생.", e);
                }
            }
        };
    }




//      Error Handler 나중에 좀 더 찾아보기,,ㅜ^ㅜ
//    public class RestResponseErrorHandler extends DefaultResponseErrorHandler {
//        @Override
//        public void handleError(ClientHttpResponse response) throws IOException {
//            log.error("Has error response: {}", response);
//            super.handleError(response);
//        }
//
//        @Override
//        public boolean hasError(ClientHttpResponse response) throws IOException {
//            log.error("Has error response: {}", response);
//            return super.hasError(response);
//        }
//    }
}
