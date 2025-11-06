//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//


import UIKit
import Combine
import Factory

final class WeatherDetailViewController: UIViewController {
    // MARK: UI
    private let header          = UIView()
    private let favBtn          = UIButton(type: .system)
    private let cityLbl         = UILabel()
    private let searchBtn       = UIButton(type: .system)
    
    private let iconIV          = UIImageView()
    private let tempLbl         = UILabel()
    private let descLbl         = UILabel()
    
    private let metricsStack    = UIStackView()
    private let humLbl          = UILabel()
    private let pressLbl        = UILabel()
    private let windLbl         = UILabel()
    
    private let weekTitle       = UILabel()
    private let table           = UITableView()
    
    // MARK: Data
    var forecast: ForecastResponse? { didSet { configure() } }
    private var daily: [DailySummary] = []
    private var cancellables = Set<AnyCancellable>()
    
    @Injected(\.weatherViewModel) private var vm: WeatherViewModel
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildUI()
        configure()
    }
    
    // MARK: UI
    private func buildUI() {
        // Header
        favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        favBtn.tintColor = .systemRed
        favBtn.addTarget(self, action: #selector(toggleFav), for: .touchUpInside)
        
        cityLbl.font = .systemFont(ofSize: 20, weight: .semibold)
        cityLbl.textAlignment = .center
        
        searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchBtn.tintColor = .label
        
        header.addSubview(favBtn); header.addSubview(cityLbl); header.addSubview(searchBtn)
        
        // Icon
        iconIV.contentMode = .scaleAspectFit
        
        // Temp / Desc
        tempLbl.font = .systemFont(ofSize: 48, weight: .bold)
        tempLbl.textAlignment = .center
        descLbl.font = .systemFont(ofSize: 18, weight: .medium)
        descLbl.textAlignment = .center
        
        // Metrics
        metricsStack.axis = .horizontal
        metricsStack.distribution = .fillEqually
        [humLbl, pressLbl, windLbl].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textAlignment = .center
            metricsStack.addArrangedSubview($0)
        }
        
        // Week title
        weekTitle.text = "This Week"
        weekTitle.font = .boldSystemFont(ofSize: 18)
        weekTitle.textAlignment = .center
        
        // Table
        table.register(ForecastDayCell.self, forCellReuseIdentifier: ForecastDayCell.id)
        table.dataSource = self
        table.rowHeight = 60
        table.separatorStyle = .none
        
        // Hierarchy
        [header, iconIV, tempLbl, descLbl, metricsStack, weekTitle, table]
            .forEach { view.addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // Layout
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),
            
            favBtn.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            favBtn.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            cityLbl.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            cityLbl.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            searchBtn.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            searchBtn.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            iconIV.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 24),
            iconIV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconIV.widthAnchor.constraint(equalToConstant: 120),
            iconIV.heightAnchor.constraint(equalToConstant: 120),
            
            tempLbl.topAnchor.constraint(equalTo: iconIV.bottomAnchor, constant: 12),
            tempLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descLbl.topAnchor.constraint(equalTo: tempLbl.bottomAnchor, constant: 4),
            descLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            metricsStack.topAnchor.constraint(equalTo: descLbl.bottomAnchor, constant: 16),
            metricsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            metricsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            weekTitle.topAnchor.constraint(equalTo: metricsStack.bottomAnchor, constant: 24),
            weekTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            table.topAnchor.constraint(equalTo: weekTitle.bottomAnchor, constant: 8),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Configure
    private func configure() {
        guard let f = forecast, viewIfLoaded != nil else { return }
        cityLbl.text = f.city.name
        
        // favourite state
        let fav = FavouriteModel(city: f.city.name, country: f.city.country)
        let isFav = vm.favouriteCity == fav
        favBtn.setImage(UIImage(systemName: isFav ? "heart.fill" : "heart"), for: .normal)
        
        // Current (first 3-hour)
        if let cur = f.list.first {
            tempLbl.text = "\(Int(cur.main.temp))°"
            descLbl.text = cur.weather.first?.description.capitalized ?? "–"
            
            humLbl.text  = "Humidity \(cur.main.humidity)%"
            pressLbl.text = "Pressure \(cur.main.pressure) hPa"
            windLbl.text  = "Wind \(String(format: "%.1f", cur.wind.speed)) m/s"
            
            loadIcon(cur.weather.first?.icon ?? "01d", into: iconIV, size: "@2x")
        }
        
        daily = f.dailySummaries
        table.reloadData()
    }
    
    @objc private func toggleFav() {
        guard let f = forecast else { return }
        let fav = FavouriteModel(city: f.city.name, country: f.city.country)
        if vm.favouriteCity == fav {
            vm.clearFavourite()
        } else {
            vm.setFavourite(city: f.city.name, country: f.city.country)
        }
        configure()          // refresh heart
    }
    
    private func loadIcon(_ code: String, into iv: UIImageView, size: String = "@2x") {
        let url = URL(string: "https://openweathermap.org/img/wn/\(code)\(size).png")!
        URLSession.shared.dataTask(with: url) { d, _, _ in
            if let d = d, let img = UIImage(data: d) {
                DispatchQueue.main.async { iv.image = img }
            }
        }.resume()
    }
}

// MARK: Table
extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { daily.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayCell.id, for: indexPath) as! ForecastDayCell
        cell.configure(with: daily[indexPath.row])
        return cell
    }
}

// MARK: Cell
final class ForecastDayCell: UITableViewCell {
    static let id = "ForecastDayCell"
    private let dayL = UILabel()
    private let icon = UIImageView()
    private let desc = UILabel()
    private let temp = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        build()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func build() {
        [dayL, icon, desc, temp].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        dayL.font = .systemFont(ofSize: 14, weight: .medium)
        desc.font = .systemFont(ofSize: 14)
        temp.font = .boldSystemFont(ofSize: 16)
        icon.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            dayL.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayL.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            icon.leadingAnchor.constraint(equalTo: dayL.trailingAnchor, constant: 12),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            desc.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            desc.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            temp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with day: DailySummary) {
        let fmt = DateFormatter(); fmt.dateFormat = "E"
        dayL.text = fmt.string(from: day.date)
        desc.text = day.description
        temp.text = day.high > 0 ? "\(Int(day.high))° / \(Int(day.low))°" : "–"
        if let url = URL(string: "https://openweathermap.org/img/wn/\(day.icon).png") {
            URLSession.shared.dataTask(with: url) { d, _, _ in
                if let d = d, let img = UIImage(data: d) {
                    DispatchQueue.main.async { self.icon.image = img }
                }
            }.resume()
        }
    }
}
