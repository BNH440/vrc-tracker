import fetch from "node-fetch";

async function main() {
    while (true) {
        //log response time
        console.time("fetch");
        //fetch data
        // await fetch("http://localhost:3000/teams?search=295S&grade=High%20School");
        await fetch("https://api.vrctracker.blakehaug.com/teams?search=295S&grade=High%20School");
        //log response time
        console.timeEnd("fetch");
    }
}

main();
