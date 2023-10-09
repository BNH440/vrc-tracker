import request from "request";
import fs from "fs";
import dotenv from "dotenv";

// This file gets the team list from the API and saves it to a JSON file

dotenv.config();

let teamList = [];

function checkPages() {
    let options = {
        method: "GET",
        url: "https://www.robotevents.com/api/v2/teams?program=1&per_page=250&page=1&sort=team_number",
        headers: {
            Accept: "application/json",
            Authorization: `Bearer ${process.env.API_KEY}`,
        },
    };

    return new Promise(function (resolve, reject) {
        request(options, function (error, response) {
            if (error) reject(error);
            resolve(parseInt(JSON.parse(response.body).meta.last_page));
        });
    });
}

async function requests() {
    let last_page = await checkPages();

    await new Promise((resolve) => setTimeout(resolve, 1000));

    for (let i = 1; i <= last_page; i++) {
        let options = {
            method: "GET",
            url: "https://www.robotevents.com/api/v2/teams?program=1&per_page=250&page=" + i + "&sort=team_number",
            headers: {
                Accept: "application/json",
                Authorization: `Bearer ${process.env.API_KEY}`,
            },
        };
        request(options, function (error, response) {
            if (error) throw new Error(error);

            let list = [];

            for (let team of JSON.parse(response.body).data) {
                if (team.registered == true) {
                    list.push({
                        id: team.id,
                        number: team.number,
                        team_name: team.team_name,
                        organization: team.organization,
                        grade: team.grade,
                    });
                }
            }

            teamList = teamList.concat(list);

            console.log(teamList.length);
        });

        await new Promise((resolve) => setTimeout(resolve, 1000));
    }
}

requests().then(async () => {
    await new Promise((resolve) => setTimeout(resolve, 10000));

    if (teamList.length < 1) {
        throw new Error("No teams in the list");
    }

    fs.writeFile("/app/data/teamList.json", JSON.stringify(teamList), function (err) {
        if (err) {
            return console.log(err);
        }
        console.log("The file was saved");
    });
});
