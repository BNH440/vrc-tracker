import express from "express";
import fs from "fs";
import Fuse from "fuse.js";

// Simple API to search through the team list and return the results

const app = express();

let teamList = JSON.parse(fs.readFileSync("teamList.json"));
let hsteamList = teamList.filter((team) => team.grade == "High School");
let msteamList = teamList.filter((team) => team.grade == "Middle School");

app.get("/teams", (req, res) => {
    let search = req.query.search;
    let grade = req.query.grade;

    if (search.length < 1) {
        search = "";
    }

    let filteredTeamList = [];

    if (grade == "High School") {
        filteredTeamList = hsteamList;
    } else if (grade == "Middle School") {
        filteredTeamList = msteamList;
    } else {
        filteredTeamList = teamList;
    }

    let options = {
        keys: ["number", "team_name", "organization"],
        threshold: 0.3,
    };
    let fuse = new Fuse(filteredTeamList, options);
    let teams = fuse.search(search);

    teams.length = Math.min(teams.length, 30);

    res.send(teams);
});

app.listen(3000, () => {
    console.log("Server running on port 3000");
});
