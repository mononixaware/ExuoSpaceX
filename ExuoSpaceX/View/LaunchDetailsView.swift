//
//  LaunchDetailsView.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI
import YouTubePlayerKit

struct LaunchDetailsView: View {
	@EnvironmentObject var vm: LaunchesViewModel
	let launch: Launch
	var youtubePlayer: YouTubePlayer?
	
	init(launch: Launch) {
		self.launch = launch
		
		if let youtubeId = launch.links?.youtube_id {
			youtubePlayer = YouTubePlayer(
				source: .video(id: youtubeId),
				configuration: .init(autoPlay: false)
			)
		}
	}
	
	var body: some View {
		VStack(spacing: 18) {
			youtube
			
			VStack(spacing: 12) {
				Text("\(launch.name)")
					.fontWeight(.semibold)
					.foregroundColor(Color.accentColor)
				
				Text("\(launch.date_utc.spaceXTime)")
				
				fancyLaunchDetails
				
				Text("Rocket Name: \(vm.rocket?.name ?? "unknown")")
				
				Text("Payload Mass: \(vm.rocket?.payload_weights?.first?.kg ?? 0) kg")
				
				wikipediaLink
			}
			.overlay(favButton, alignment: .topTrailing)
			
			Spacer()
		}
		.onAppear {
			vm.getRocket(rocketId: launch.rocket)
		}
	}
}

extension LaunchDetailsView {
	private var youtube: some View {
		ZStack {
			if let youtubePlayer = youtubePlayer {
				YouTubePlayerView(youtubePlayer)
					.scaledToFit()
			} else {
				VStack {
					Text("Oh snap 😶‍🌫️")
						.padding(.bottom, 8)
					
					Text("There was a problem loading YouTube video\nPlease try again later")
						.font(.footnote)
						.multilineTextAlignment(.center)
				}
				.foregroundColor(Color.white)
				.padding(.vertical, 80)
			}
		}
		.frame(maxWidth: .infinity)
		.background(Color.black)
	}
	
	private var fancyLaunchDetails: some View {
		ZStack {
			if let details = launch.details {
				ScrollView {
					Text(details)
						.font(.footnote)
						.fontWeight(.light)
						.lineLimit(nil)
						.multilineTextAlignment(.center)
						.padding(.trailing, 16)
				}
			} else {
				Text("🚀 Details not available 🫣")
					.font(.footnote)
					.fontWeight(.light)
			}
		}
		.padding()
		.padding(.trailing, -16)
		.frame(maxWidth: .infinity, minHeight: 92)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(.ultraThinMaterial)
		)
		.padding(.horizontal)
	}
	
	private var wikipediaLink: some View {
		ZStack {
			if let wikipediaLink = launch.links?.wikipedia {
				Link("Wikipedia", destination: URL(string: wikipediaLink)!)
					.foregroundColor(Color.blue)
			}
		}
	}
	
	private var favButton: some View {
		Image(systemName: vm.isFav(launchId: launch.id) ? "heart.fill" : "heart")
			.foregroundColor(Color.accentColor)
			.padding(.trailing)
			.onTapGesture {
				vm.favTapped(launchId: launch.id)
			}
	}
}

