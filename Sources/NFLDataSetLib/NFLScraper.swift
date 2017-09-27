//MIT License
//
//Copyright (c) 2017 Manny Guerrero
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation
import CSV
import Kanna

public final class NFLScraper {
    
    public init() {}
    
    public func generateCSVFile() {
        guard let desktopPath = createCSVFile() else {
            return
        }
        guard let stream = OutputStream(toFileAtPath: desktopPath.path, append: false) else {
            removeCSVFile(pathToFile: desktopPath)
            return
        }
        // Setup CSV writer
        let csv = try! CSVWriter(stream: stream)
        // Setup header row
        try! csv.write(row: ["SEASON",
                             "WEEK",
                             "HOME_TEAM_NAME",
                             "HOME_TEAM_FINAL_SCORE",
                             "HOME_TEAM_SCORE_Q1",
                             "HOME_TEAM_SCORE_Q2",
                             "HOME_TEAM_SCORE_Q3",
                             "HOME_TEAM_SCORE_Q4",
                             "HOMT_TEAM_SCORE_OT",
                             "HOME_TEAM_TOTAL_WINS",
                             "HOME_TEAM_TOTAL_LOSSES",
                             "HOME_TEAM_TOTAL_TIES",
                             "AWAY_TEAM_NAME",
                             "AWAY_TEAM_FINAL_SCORE",
                             "AWAY_TEAM_SCORE_Q1",
                             "AWAY_TEAM_SCORE_Q2",
                             "AWAY_TEAM_SCORE_Q3",
                             "AWAY_TEAM_SCORE_Q4",
                             "AWAY_TEAM_SCORE_OT",
                             "AWAY_TEAM_TOTAL_WINS",
                             "AWAY_TEAM_TOTAL_LOSSES",
                             "AWAY_TEAM_TOTAL_TIES",
                             "WINNER"])
        // Begin scraping data
        for i in 2009...2016 {
            for j in 1...17 {
                let season = i
                let week = j
                print("Beginning retrieving data for season \(season), week \(week)")
                var homeTeamName: String?
                var homeTeamScore: Int?
                var homeTeamScoreQ1: Int?
                var homeTeamScoreQ2: Int?
                var homeTeamScoreQ3: Int?
                var homeTeamScoreQ4: Int?
                var homeTeamScoreOT: Int?
                var homeTeamTotalWins: Int?
                var homeTeamTotalLosses: Int?
                var homeTeamTotalTies: Int?
                var awayTeamName: String?
                var awayTeamScore: Int?
                var awayTeamScoreQ1: Int?
                var awayTeamScoreQ2: Int?
                var awayTeamScoreQ3: Int?
                var awayTeamScoreQ4: Int?
                var awayTeamScoreOT: Int?
                var awayTeamTotalWins: Int?
                var awayTeamTotalLosses: Int?
                var awayTeamTotalTies: Int?
                let winner: String
                let nflLivePath = "http://www.nfl.com/scores/\(season)/REG\(week)"
                let url = URL(string: nflLivePath)!
                guard let htmlDoc = HTML(url: url, encoding: .utf8) else {
                    removeCSVFile(pathToFile: desktopPath)
                    fatalError("Error retriving data for season \(season), week \(week)!")
                }
                let scoreBoxNodes = htmlDoc.xpath("//div[@class='new-score-box-wrapper']")
                for scoreBoxNode in scoreBoxNodes {
                    guard let newScoreBoxNode = scoreBoxNode.at_css("div[class=new-score-box]") else {
                        removeCSVFile(pathToFile: desktopPath)
                        fatalError("Error retriving data for season \(season), week \(week)!")
                    }
                    guard let awayTeamWrapperNode = newScoreBoxNode.at_xpath("div/div[@class='away-team']") else {
                        removeCSVFile(pathToFile: desktopPath)
                        fatalError("Error retriving data for season \(season), week \(week)!")
                    }
                    guard let homeTeamWrapperNode = newScoreBoxNode.at_xpath("div/div[@class='home-team']") else {
                        removeCSVFile(pathToFile: desktopPath)
                        fatalError("Error retriving data for season \(season), week \(week)!")
                    }
                    retrieveGameData(teamName: &homeTeamName,
                                     teamScore: &homeTeamScore,
                                     teamScoreQ1: &homeTeamScoreQ1,
                                     teamScoreQ2: &homeTeamScoreQ2,
                                     teamScoreQ3: &homeTeamScoreQ3,
                                     teamScoreQ4: &homeTeamScoreQ4,
                                     teamScoreOT: &homeTeamScoreOT,
                                     teamTotalWins: &homeTeamTotalWins,
                                     teamTotalLosses: &homeTeamTotalLosses,
                                     teamTotalTies: &homeTeamTotalTies,
                                     teamWrapperNode: homeTeamWrapperNode)
                    retrieveGameData(teamName: &awayTeamName,
                                     teamScore: &awayTeamScore,
                                     teamScoreQ1: &awayTeamScoreQ1,
                                     teamScoreQ2: &awayTeamScoreQ2,
                                     teamScoreQ3: &awayTeamScoreQ3,
                                     teamScoreQ4: &awayTeamScoreQ4,
                                     teamScoreOT: &awayTeamScoreOT,
                                     teamTotalWins: &awayTeamTotalWins,
                                     teamTotalLosses: &awayTeamTotalLosses,
                                     teamTotalTies: &awayTeamTotalTies,
                                     teamWrapperNode: awayTeamWrapperNode)
                }
                guard homeTeamName != nil,
                      homeTeamScore != nil,
                      homeTeamScoreQ1 != nil,
                      homeTeamScoreQ2 != nil,
                      homeTeamScoreQ3 != nil,
                      homeTeamScoreQ4 != nil,
                      homeTeamScoreOT != nil,
                      homeTeamTotalWins != nil,
                      homeTeamTotalLosses != nil,
                      homeTeamTotalTies != nil,
                      awayTeamName != nil,
                      awayTeamScore != nil,
                      awayTeamScoreQ1 != nil,
                      awayTeamScoreQ2 != nil,
                      awayTeamScoreQ3 != nil,
                      awayTeamScoreQ4 != nil,
                      awayTeamScoreOT != nil,
                      awayTeamTotalWins != nil,
                      awayTeamTotalLosses != nil,
                      awayTeamTotalTies != nil else {
                        removeCSVFile(pathToFile: desktopPath)
                        fatalError("Error retriving data for season \(season), week \(week)!")
                }
                // Calculate winner
                if homeTeamScore! > awayTeamScore! {
                    winner = homeTeamName!
                } else {
                    winner = awayTeamName!
                }
                // Write to file
                try! csv.write(row: ["\(season)",
                                     "\(week)",
                                     homeTeamName!,
                                     "\(homeTeamScore!)",
                                     "\(homeTeamScoreQ1!)",
                                     "\(homeTeamScoreQ2!)",
                                     "\(homeTeamScoreQ3!)",
                                     "\(homeTeamScoreQ4!)",
                                     "\(homeTeamScoreOT!)",
                                     "\(homeTeamTotalWins!)",
                                     "\(homeTeamTotalLosses!)",
                                     "\(homeTeamTotalTies!)",
                                     awayTeamName!,
                                     "\(awayTeamScore!)",
                                     "\(awayTeamScoreQ1!)",
                                     "\(awayTeamScoreQ2!)",
                                     "\(awayTeamScoreQ3!)",
                                     "\(awayTeamScoreQ4!)",
                                     "\(awayTeamScoreOT!)",
                                     "\(awayTeamTotalWins!)",
                                     "\(awayTeamTotalLosses!)",
                                     "\(awayTeamTotalTies!)",
                                     winner])
                print("Finished retrieving data for season \(season), week \(week)")
            }
        }
        csv.stream.close()
        print("Finished generating NFL dataset")
        print("Dataset file can be found at \(desktopPath.path)")
    }
}


// MARK: - Private Instance Methods
fileprivate extension NFLScraper {
    func createCSVFile() -> URL? {
        let fileManager = FileManager.default
        let homePath: URL
        if #available(OSX 10.12, *) {
            homePath = fileManager.homeDirectoryForCurrentUser
        } else {
            print("File path cannot be determined in non OSX environment")
            return nil
        }
        let desktopPath = homePath.appendingPathComponent("Desktop/nfl-dataset.csv")
        print("Path to use for adding csv file: \(desktopPath)")
        fileManager.createFile(atPath: desktopPath.path, contents: nil, attributes: nil)
        return desktopPath
    }
    
    func removeCSVFile(pathToFile: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: pathToFile)
        } catch {
            fatalError("Error trying to delete file!")
        }
    }
    
    func retrieveGameData(teamName: inout String?,
                          teamScore: inout Int?,
                          teamScoreQ1: inout Int?,
                          teamScoreQ2: inout Int?,
                          teamScoreQ3: inout Int?,
                          teamScoreQ4: inout Int?,
                          teamScoreOT: inout Int?,
                          teamTotalWins: inout Int?,
                          teamTotalLosses: inout Int?,
                          teamTotalTies: inout Int?,
                          teamWrapperNode: SearchableNode) {
        // Retrieve team data node
        if let teamDataNode = teamWrapperNode.at_xpath("div[@class='team-data']") {
            // Retrieve total score node
            if let totalScoreNode = teamDataNode.at_css("p[class=total-score]") {
                if let content = totalScoreNode.content,
                   let score = content.intValue {
                    teamScore = score
                }
            }
            // Retrieve quarter scores
            if let quartersScoreNode = teamDataNode.at_css("p[class=quarters-score]") {
                // Retrieve first quarter score
                if let firstQuarterScoreNode = quartersScoreNode.at_css("span[class=first-qt]") {
                    if let content = firstQuarterScoreNode.content,
                       let score = content.intValue {
                        teamScoreQ1 = score
                    }
                }
                // Retrieve second quarter score
                if let secondQuarterScoreNode = quartersScoreNode.at_css("span[class=second-qt]") {
                    if let content = secondQuarterScoreNode.content,
                       let score = content.intValue {
                        teamScoreQ2 = score
                    }
                }
                // Retrieve third quarter score
                if let thirdQuarterScoreNode = quartersScoreNode.at_css("span[class=third-qt]") {
                    if let content = thirdQuarterScoreNode.content,
                       let score = content.intValue {
                        teamScoreQ3 = score
                    }
                }
                // Retrieve fourth quarter score
                if let fourthQuarterScoreNode = quartersScoreNode.at_css("span[class=fourth-qt]") {
                    if let content = fourthQuarterScoreNode.content,
                       let score = content.intValue {
                        teamScoreQ4 = score
                    }
                }
                // Retrieve overtime score
                if let overtimeScoreNode = quartersScoreNode.at_css("span[class=ot-qt]") {
                    if let content = overtimeScoreNode.content,
                       let score = content.intValue {
                        teamScoreOT = score
                    } else {
                        // There was no overtime
                        teamScoreOT = 0
                    }
                }
            }
            // Retrieve team info
            if let teamInfoNode = teamDataNode.at_css("div[class=team-info]") {
                // Retrieve team record
                if let teamRecordNode = teamInfoNode.at_css("p[class=team-record]") {
                    if let aRecordElement = teamRecordNode.at_xpath("a") {
                        if let content = aRecordElement.content {
                            let trimmedString = content.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                            let recordStrings = trimmedString.components(separatedBy: "-")
                            // Retrieve total wins
                            if let totalWins = recordStrings[0].intValue {
                                teamTotalWins = totalWins
                            }
                            // Retrieve total losses
                            if let totalLosses = recordStrings[1].intValue {
                                teamTotalLosses = totalLosses
                            }
                            // Retrieve total ties
                            if let totalTies = recordStrings[2].intValue {
                                teamTotalTies = totalTies
                            }
                        }
                    }
                }
                // Retrieve team name
                if let teamNameNode = teamInfoNode.at_css("p[class=team-name]") {
                    if let aNameElement = teamNameNode.at_xpath("a") {
                        if let content = aNameElement.content {
                            teamName = content
                        }
                    }
                }
            }
        }
    }
}
