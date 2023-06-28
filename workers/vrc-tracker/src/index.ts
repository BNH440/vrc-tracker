export interface Env {
    API_KEY: string;
}

const seasonId = 173;

export default {
    async fetch(request: Request, env: Env, ctx: ExecutionContext) {
        const API_KEY = env.API_KEY;
        return await handleRequest(request, env).catch((err) => new Response(err.stack, { status: 500 }));
    },
};

const seasonId = 181; // 173 for spin up

async function handleRequest(request: Request<unknown>, env: Env) {
    const requestHeaders = {
        headers: {
            Accept: "application/json",
            Authorization: `Bearer ${env.API_KEY}`,
        },
    };

    const responseHeaders = {
        headers: {
            "Content-Type": "application/json",
        },
    };

    const { pathname, searchParams } = new URL(request.url);
    const cacheUrl = new URL(request.url);

    const cacheKey = request;
    const cache = caches.default;

    var cacheResponse = await cache.match(cacheKey);

    if (!cacheResponse) {
        console.log(`Cache miss for: ${request.url}.`);
        if (pathname.startsWith("/eventList")) {
            const date = searchParams.get("date");
            let apiResponse = await fetch(`https://www.robotevents.com/api/v2/events?season[]=${seasonId}&start=${date}&per_page=1000`, {
                ...requestHeaders,
                cf: {
                    cacheTtl: 7200,
                    cacheEverything: true,
                },
            });

            let response = new Response(apiResponse.body, {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=7200");
                response.headers.append("Cache-Control", "max-age=7200");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else if (pathname.startsWith("/eventDetails")) {
            const event = searchParams.get("event");
            let apiResponse = await fetch(`https://www.robotevents.com/api/v2/events/${event}`, {
                ...requestHeaders,
                cf: {
                    cacheTtl: 1800,
                    cacheEverything: true,
                },
            });

            let response = new Response(apiResponse.body, {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=1800");
                response.headers.append("Cache-Control", "max-age=1800");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else if (pathname.startsWith("/teamList")) {
            const event = searchParams.get("event");
            let apiResponse = await fetch(`https://www.robotevents.com/api/v2/events/${event}/teams?per_page=1000`, {
                ...requestHeaders,
                cf: {
                    cacheTtl: 1800,
                    cacheEverything: true,
                },
            });

            let response = new Response(apiResponse.body, {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=1800");
                response.headers.append("Cache-Control", "max-age=1800");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else if (pathname.startsWith("/teamDetails")) {
            const team = searchParams.get("team");
            let apiResponse = await fetch(`https://www.robotevents.com/api/v2/teams/${team}`, {
                ...requestHeaders,
                cf: {
                    cacheTtl: 86400,
                    cacheEverything: true,
                },
            });

            let response = new Response(apiResponse.body, {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=86400");
                response.headers.append("Cache-Control", "max-age=86400");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else if (pathname.startsWith("/teamEvents")) {
            const team = searchParams.get("team");
            let apiResponse = await fetch(`https://www.robotevents.com/api/v2/teams/${team}/events?season[]=${seasonId}&per_page=1000`, {
                ...requestHeaders,
                cf: {
                    cacheTtl: 86400,
                    cacheEverything: true,
                },
            });

            let response = new Response(apiResponse.body, {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=86400");
                response.headers.append("Cache-Control", "max-age=86400");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else if (pathname.startsWith("/predict")) {
            const red1 = searchParams.get("red1");
            const red2 = searchParams.get("red2");
            const blue1 = searchParams.get("blue1");
            const blue2 = searchParams.get("blue2");

            let apiResponse = await fetch(`http://vrc-data-analysis.com/v1/predict/${red1}/${red2}/${blue1}/${blue2}`, {
                headers: {
                    Accept: "application/json",
                },
                cf: {
                    cacheTtl: 86400,
                    cacheEverything: true,
                },
            });

            let response = new Response(apiResponse.body, {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=86400");
                response.headers.append("Cache-Control", "max-age=86400");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else if (pathname.startsWith("/v2/eventList")) {
            const date = searchParams.get("date");
            let apiResponse = await fetch(`https://www.robotevents.com/api/v2/events?season[]=${seasonId}&start=${date}&per_page=250`, {
                ...requestHeaders,
                cf: {
                    cacheTtl: 7200,
                    cacheEverything: true,
                },
            });

            var data: any = await apiResponse.json();

            var responseData = data.data;

            if (data.meta.last_page > 1) {
                for (let i = 2; i <= data.meta.last_page; i++) {
                    let apiResponse = await fetch(
                        `https://www.robotevents.com/api/v2/events?season[]=${seasonId}&start=${date}&per_page=250&page=${i}`,
                        {
                            ...requestHeaders,
                            cf: {
                                cacheTtl: 7200,
                                cacheEverything: true,
                            },
                        }
                    );

                    var newData: any = await apiResponse.json();
                    responseData = responseData.concat(newData.data);
                }
            }

            let response = new Response(JSON.stringify(responseData), {
                ...responseHeaders,
                status: apiResponse.status,
            });

            if (apiResponse.status == 200) {
                response.headers.append("Cache-Control", "s-maxage=7200");
                response.headers.append("Cache-Control", "max-age=7200");
            }

            await cache.put(cacheKey, response.clone());

            return response;
        } else {
            return new Response("/ is not a valid path");
        }
    } else {
        console.log(`Cache hit for: ${request.url}.`);
        return cacheResponse;
    }
}
