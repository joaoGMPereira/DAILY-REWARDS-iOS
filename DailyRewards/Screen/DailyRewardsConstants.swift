//
//  ChallengeConstants.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 28/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation

enum KeychainConstants: String {
    case dailyRewards = "com.br.ios.daily.rewards.DailyRewards"
}
enum HeroConstants: String {
    case profileImageHero = "profileImageHero"
    case profileNameHero = "profileNameHero"
    case challengeImageHero = "challengeImageHero"
}
enum LottieConstants: String {
    case infityLoop = "infinityLottieOrange"
    case plusMinus = "plusMinusLottieOrange"
    case closeLottieOrange = "closeLottieOrange"
}

enum ImagesConstants: String {
    case exitAppIconWhite = "exitAppIconWhite"
}

enum ProfileConstants: String {
    case title = "Profile"
    case npsTitle = "Quanto você indicaria esse aplicativo para um amigo?"
    case messageAlert = "Deseja confirmar seu voto?"
    case votedMessageAlert = "Votado!"
}

enum ChallengeConstants: String {
    case myChallenges = "Meus Desafios"
    case groupChallenges = "Desafios em Grupo"
    case objectives = "Objectivos"
    
}
