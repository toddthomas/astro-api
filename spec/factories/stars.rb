FactoryBot.define do
  factory :star do
    factory :beta_persei do
      identifier { '* bet Per' }
      right_ascension { 2.34 }
      declination { -23.4 }
      visual_magnitude { 5.0 }
      spectral_type { 'B8V' }
    end

    factory :alpha_cygni do
      identifier { '* alf Cyg' }
      right_ascension { 20.69053198333333 }
      declination { -45.28033880555555 }
      visual_magnitude { 1.25 }
      spectral_type { 'A2Ia' }
    end

    factory :gamma_cassiopeiae do
      identifier { '* gam Cas' }
      right_ascension { 0.9451476944444445 }
      declination { 60.71674027777778 }
      visual_magnitude { 2.39 }
      spectral_type { 'B0.5IVpe' }
    end

    factory :betelgeuse do
      identifier { '* alf Ori' }
      right_ascension { 5.919529266666667 }
      declination { 7.407064 }
      visual_magnitude { 0.42 }
      spectral_type { 'M1-M2Ia-Iab' }
    end
  end
end
